package {
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.system.MessageChannel;
	import flash.system.Worker;
	import flash.system.WorkerDomain;
	
	public class Main extends Sprite {
		private var worker:Worker;
		private var wtm:MessageChannel;
		private var mtw:MessageChannel;
		
		public function Main() {
			this.worker = WorkerDomain.current.createWorker( Workers.MyWorker );
			
			this.wtm = worker.createMessageChannel( Worker.current );
			this.mtw = Worker.current.createMessageChannel( Worker.current );
			
			this.worker.setSharedProperty( "wtm", this.wtm );
			this.worker.setSharedProperty( "mtw", this.mtw );
			
			this.wtm.addEventListener( Event.CHANNEL_MESSAGE, onMessageHandler );
			
			this.worker.start();
		}
		
		protected function onMessageHandler( e:Event ):void {
			trace( this.wtm.receive() );
		}
	}
}