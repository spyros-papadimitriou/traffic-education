package general
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.utils.getDefinitionByName;

	public class Preloader extends MovieClip
	{
		private var textFormat:TextFormat;
		private var tf:TextField;
		private var shape:Sprite;
		
		[Embed(source="/assets/fonts/verdana.ttf", fontName="verdanaFont", mimeType="application/x-font", fontWeight="bold", fontStyle="normal", unicodeRange="U+0020,U+0041-005A, U+0020,U+0061-007A, U+0030-0039,U+002E, U+0020-002F,U+003A-0040,U+005B-0060,U+007B-007E, U+0020-002F,U+0030-0039,U+003A-0040,U+0041-005A,U+005B-0060,U+0061-007A,U+007B-007E, U+0374-03F2,U+1F00-1FFE,U+2000-206F,U+20A0-20CF,U+2100-2183", advancedAntiAliasing="true", embedAsCFF="false")]
		public static const VerdanaFont:Class 
	
		public function Preloader():void
		{
			stop();
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		} // end constructor
		
		private function onAddedToStage(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

			shape = new Sprite();
			shape.graphics.beginFill(0xDDDDDD);
			shape.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			shape.graphics.endFill();

			textFormat = new TextFormat("verdanaFont", 22, 0x000000, true);
			textFormat.align = "center";
			textFormat.size = 24;
			textFormat.bold = true;

			tf = new TextField();
			tf.selectable = false;
			tf.embedFonts = true;
			tf.defaultTextFormat = textFormat;
			tf.setTextFormat(textFormat);
			tf.border = false;
			tf.multiline = true;
			tf.wordWrap = true;
			tf.width = 350;
			tf.height = 150;
			tf.x = (stage.stageWidth - tf.width) / 2;
			tf.y = (stage.stageHeight - tf.height) / 2;
			
			addChild(shape);
			addChild(tf);
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			trace('preloader');
		}
		
		private function onEnterFrame(e:Event):void
		{
			if (framesLoaded == totalFrames)
			{
				removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				nextFrame();
				init();
			} else {
				var percent:Number = Math.round(100 * (root.loaderInfo.bytesLoaded / root.loaderInfo.bytesTotal));
				tf.text = "ΚΥΚΛΟΦΟΡΙΑΚΗ ΑΓΩΓΗ\nΠαρακαλώ περιμένετε\n" + percent.toString() + "%";
			}
		}
		
		private function init():void
		{
			var mainClass:Class = Class(getDefinitionByName('Main'));
			if (mainClass)
			{
				var main:Object = new mainClass();
				addChild(main as DisplayObject);
			}
		}
	
	} // end class

} // end package
