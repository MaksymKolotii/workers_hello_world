package {
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.FileReference;
	import flash.net.FileReferenceList;
	import flash.system.MessageChannel;
	import flash.system.Worker;
	import flash.system.WorkerDomain;
	
	public class Main extends Sprite {
		
		private var worker:Worker;
		private var wtm:MessageChannel;
		private var mtw:MessageChannel;
		private var gui:ui;
		private var wavList:FileReferenceList;
		private var file:FileReference;
		
		public function Main() {
			this.gui = new ui();
			this.gui.loadbar.scaleX = 0;
			this.gui.x = 300;
			this.gui.y = 200;
			addChild( this.gui );
			
			this.gui.addEventListener( MouseEvent.CLICK, onLoadClickHandler );
			
			this.wavList = new FileReferenceList();
			this.wavList.addEventListener( Event.SELECT, onFileSelectHandler );
			
			this.worker = WorkerDomain.current.createWorker( Workers.MyWorker );
			
			this.wtm = worker.createMessageChannel( Worker.current );
			this.mtw = Worker.current.createMessageChannel( worker );
			
			this.worker.setSharedProperty( "wtm", this.wtm );
			this.worker.setSharedProperty( "mtw", this.mtw );
			
			this.wtm.addEventListener( Event.CHANNEL_MESSAGE, onBackToMainHandler );
			
			this.worker.start();
		}
		
		protected function onBackToMainHandler( e:Event ):void {
			if ( this.wtm.messageAvailable ) {
				var header:String = this.wtm.receive();
				if ( header == "PROGRESS" ){
					this.gui.loadbar.scaleX = wtm.receive();
				} else if ( header == "COMPLETE" ){
					( new FileReference() ).save( this.wtm.receive() );
				}
			}
		}
		
		protected function onFileSelectHandler( e:Event ):void {
			this.file = this.wavList.fileList[0];
			this.file.addEventListener( Event.COMPLETE, onFileLoadedHandler );
			this.file.load();
		}
		
		protected function onFileLoadedHandler( e:Event ):void {
			this.mtw.send( "DATA" );
			this.mtw.send( file.data );
		}
		
		protected function onLoadClickHandler( e:MouseEvent ):void {
			this.wavList.browse();
		}
	}
}