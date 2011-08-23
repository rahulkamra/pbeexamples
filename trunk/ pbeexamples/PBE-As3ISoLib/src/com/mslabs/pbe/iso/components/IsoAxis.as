package com.mslabs.pbe.iso.components
{
    import as3isolib.display.scene.*;
    import as3isolib.enum.*;
    import as3isolib.geom.*;
    import as3isolib.graphics.*;
    import as3isolib.utils.*;
    import com.mslabs.pbe.iso.events.*;
    import com.pblabs.engine.*;
    import com.pblabs.engine.debug.*;
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;

    public class IsoAxis extends IsoOrigin
    {
        public var xAxis:Sprite;
        public var yAxis:Sprite;
        public var zAxis:Sprite;
        protected var _currentDirection:String = "up";
        protected var _lastMouseXPos:Number = 0;
        protected var _lastMouseYPos:Number = 0;
        protected var _mouseDown:Boolean = false;
        protected var _currentAxis:String = "x";

        public function IsoAxis(param1:Object = null)
        {
            this.xAxis = new Sprite();
            this.yAxis = new Sprite();
            this.zAxis = new Sprite();
            super(param1);
            this.renderAsOrphan = true;
            return;
        }// end function

        public function init() : void
        {
            this.drawGeometry();
            PBE.mainStage.addEventListener(MouseEvent.MOUSE_MOVE, this.draggingAxis);
            PBE.mainStage.addEventListener(MouseEvent.MOUSE_UP, this.mouseUpHandler);
            return;
        }// end function

        override protected function drawGeometry() : void
        {
            var _loc_2:Pt = null;
            var _loc_4:Graphics = null;
            var _loc_1:* = IsoMath.isoToScreen(new Pt(0, 0, 0));
            var _loc_3:* = IsoMath.isoToScreen(new Pt(axisLength, 0, 0));
            var _loc_5:* = new Sprite();
            _loc_5.addEventListener(MouseEvent.MOUSE_DOWN, this.dragX);
            _loc_5.addEventListener(MouseEvent.MOUSE_UP, this.mouseUpHandler);
            this.container.addChild(_loc_5);
            _loc_4 = _loc_5.graphics;
            var _loc_6:* = IStroke(strokes[0]);
            var _loc_7:* = IFill(fills[0]);
            _loc_6.apply(_loc_4);
            _loc_4.moveTo(_loc_1.x, _loc_1.y);
            _loc_4.lineTo(_loc_3.x, _loc_3.y);
            _loc_4.lineStyle(0, 0, 0);
            _loc_4.moveTo(_loc_1.x, _loc_1.y);
            _loc_4.moveTo(_loc_3.x, _loc_3.y);
            _loc_7.begin(_loc_4);
            IsoDrawingUtil.drawIsoArrow(_loc_4, new Pt(axisLength, 0), 0, arrowLength, arrowWidth);
            _loc_7.end(_loc_4);
            var _loc_8:* = new Sprite();
            _loc_8.addEventListener(MouseEvent.MOUSE_DOWN, this.dragY);
            _loc_8.addEventListener(MouseEvent.MOUSE_UP, this.mouseUpHandler);
            this.container.addChild(_loc_8);
            _loc_4 = _loc_8.graphics;
            _loc_6 = IStroke(strokes[1]);
            _loc_7 = IFill(fills[1]);
            _loc_1 = IsoMath.isoToScreen(new Pt(0, 0, 0));
            _loc_3 = IsoMath.isoToScreen(new Pt(0, axisLength, 0));
            _loc_6.apply(_loc_4);
            _loc_4.moveTo(_loc_1.x, _loc_1.y);
            _loc_4.lineTo(_loc_3.x, _loc_3.y);
            _loc_4.lineStyle(0, 0, 0);
            _loc_4.moveTo(_loc_1.x, _loc_1.y);
            _loc_4.moveTo(_loc_3.x, _loc_3.y);
            _loc_7.begin(_loc_4);
            IsoDrawingUtil.drawIsoArrow(_loc_4, new Pt(0, axisLength), 90, arrowLength, arrowWidth);
            _loc_7.end(_loc_4);
            var _loc_9:* = new Sprite();
            _loc_9.addEventListener(MouseEvent.MOUSE_DOWN, this.dragZ);
            _loc_9.addEventListener(MouseEvent.MOUSE_UP, this.mouseUpHandler);
            this.container.addChild(_loc_9);
            _loc_4 = _loc_9.graphics;
            _loc_6 = IStroke(strokes[2]);
            _loc_7 = IFill(fills[2]);
            _loc_1 = IsoMath.isoToScreen(new Pt(0, 0, 0));
            _loc_3 = IsoMath.isoToScreen(new Pt(0, 0, axisLength));
            _loc_6.apply(_loc_4);
            _loc_4.moveTo(_loc_1.x, _loc_1.y);
            _loc_4.lineTo(_loc_3.x, _loc_3.y);
            _loc_4.lineStyle(0, 0, 0);
            _loc_4.moveTo(_loc_1.x, _loc_1.y);
            _loc_7.begin(_loc_4);
            IsoDrawingUtil.drawIsoArrow(_loc_4, new Pt(0, 0, axisLength), 90, arrowLength, arrowWidth, IsoOrientation.XZ);
            _loc_7.end(_loc_4);
            _loc_4.moveTo(_loc_3.x, _loc_3.y);
            return;
        }// end function

        protected function mouseDownHandler(event:MouseEvent) : void
        {
            this._mouseDown = true;
            var _loc_2:* = this.container.localToGlobal(new Point(event.localX, event.localY));
            var _loc_3:* = _loc_2.x;
            var _loc_4:* = _loc_2.y;
            this._lastMouseXPos = _loc_3;
            this._lastMouseYPos = _loc_4;
            return;
        }// end function

        protected function mouseUpHandler(event:MouseEvent) : void
        {
            event.stopImmediatePropagation();
            this._mouseDown = false;
            return;
        }// end function

        protected function dragX(event:MouseEvent) : void
        {
            this._currentAxis = "x";
            this._mouseDown = true;
            return;
        }// end function

        protected function dragY(event:MouseEvent) : void
        {
            this._currentAxis = "y";
            this._mouseDown = true;
            return;
        }// end function

        protected function dragZ(event:MouseEvent) : void
        {
            this._currentAxis = "z";
            this._mouseDown = true;
            return;
        }// end function

        protected function draggingAxis(event:MouseEvent) : void
        {
            var _loc_5:IsoAxisEvent = null;
            var _loc_6:Number = NaN;
            var _loc_2:* = this.container.localToGlobal(new Point(event.localX, event.localY));
            var _loc_3:* = _loc_2.x;
            var _loc_4:* = _loc_2.y;
            if (this._mouseDown)
            {
                _loc_5 = new IsoAxisEvent(IsoAxisEvent.DRAGGED_AXIS, false);
                _loc_5.currentAxis = this._currentAxis;
                _loc_5.xMoveDistance = Math.abs(this._lastMouseXPos - _loc_3);
                _loc_5.yMoveDistance = Math.abs(this._lastMouseYPos - _loc_4);
                _loc_5.angleBetween = Math.atan2(_loc_3 - this._lastMouseXPos, _loc_4 - this._lastMouseYPos);
                _loc_5.differenceMultiplier = _loc_5.xMoveDistance / this._lastMouseXPos;
                _loc_5.horizonatlDirection = this.GetHorizontalDirection(_loc_3);
                _loc_5.verticalDirection = this.GetVerticalDirection(_loc_4);
                _loc_6 = Math.sqrt(Math.pow(_loc_4 - this._lastMouseYPos, 2) + Math.pow(_loc_3 - this._lastMouseXPos, 2));
                Logger.print(this, _loc_6.toString());
				
              //  eventBusSignal.dispatch(_loc_5);
            }
            event.updateAfterEvent();
            return;
        }// end function

        protected function GetHorizontalDirection(param1:Number) : String
        {
            var _loc_2:String = null;
            if (this._lastMouseXPos > param1)
            {
                _loc_2 = "left";
            }
            else if (this._lastMouseXPos < param1)
            {
                _loc_2 = "right";
            }
            else
            {
                _loc_2 = "none";
            }
            this._lastMouseXPos = param1;
            return _loc_2;
        }// end function

        protected function GetVerticalDirection(param1:Number) : String
        {
            var _loc_2:String = null;
            if (this._lastMouseYPos > param1)
            {
                _loc_2 = "up";
            }
            else if (this._lastMouseYPos < param1)
            {
                _loc_2 = "down";
            }
            else
            {
                _loc_2 = "none";
            }
            this._lastMouseYPos = param1;
            return _loc_2;
        }// end function

    }
}
