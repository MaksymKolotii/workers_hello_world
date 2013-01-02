package {
	
	import flash.display.Sprite;
	import flash.system.MessageChannel;
	import flash.system.Worker;
	
	public class MyWorker extends Sprite {
		private var wtm:MessageChannel;
		private var mtw:MessageChannel;
		
		public function MyWorker() {
			this.wtm = Worker.current.getSharedProperty( "wtm" );
			this.mtw = Worker.current.getSharedProperty( "mtw" );
			
			this.wtm.send( "Hello FlashBuilder 4.7" );
		}
	}
}