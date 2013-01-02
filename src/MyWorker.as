package {
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.system.MessageChannel;
	import flash.system.Worker;
	
	import fr.kikko.lab.ShineMP3Encoder;
	
	public class MyWorker extends Sprite {
		
		private var wtm:MessageChannel;
		private var mtw:MessageChannel;
		private var mp3Encoder:ShineMP3Encoder;
		
		public function MyWorker() {
			this.wtm = Worker.current.getSharedProperty( "wtm" );
			this.mtw = Worker.current.getSharedProperty( "mtw" );
			
			this.mtw.addEventListener( Event.CHANNEL_MESSAGE, onMainToBack );
		}
		
		protected function onMainToBack( e:Event ):void {
			if ( this.mp3Encoder == null ) {
				this.mp3Encoder = new ShineMP3Encoder( this.mtw.receive() );
				this.mp3Encoder.addEventListener( Event.COMPLETE, encodeCompleteHandler );
				this.mp3Encoder.addEventListener( ProgressEvent.PROGRESS, onEncodeProgressHandler );
				this.mp3Encoder.start();
			}
		}
		
		protected function onEncodeProgressHandler( e:ProgressEvent ):void {
			this.wtm.send( "PROGRESS");
			this.wtm.send( e.bytesLoaded / e.bytesTotal );
		}
		
		protected function encodeCompleteHandler( e:Event ):void {
			this.wtm.send( "COMPLETE" );
			this.wtm.send( this.mp3Encoder.mp3Data );
			this.mp3Encoder = null;
		}
	}
}