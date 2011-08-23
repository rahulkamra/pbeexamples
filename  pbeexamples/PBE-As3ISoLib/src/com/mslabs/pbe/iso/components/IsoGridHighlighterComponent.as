package com.mslabs.pbe.iso.components
{
    import as3isolib.geom.*;
    import com.mslabs.utils.*;
    import com.pblabs.engine.entity.*;
    import flash.display.*;
    import flash.events.*;
    import mx.events.*;

    public class IsoGridHighlighterComponent extends EntityComponent
    {
        public var gridComponentReference:PropertyReference;
        public var highlightColor:uint = 65280;
        public var currentGridPoint:Pt;
        protected var _gridComp:IsoGridComponent;
        protected var _highlight:Shape;
        protected var _currentGridX:int;
        protected var _currentGridY:int;
        protected var _enabled:Boolean = true;
        protected var _cellSize:int = 0;
        private var _connected:Boolean = false;

        public function IsoGridHighlighterComponent()
        {
            this.currentGridPoint = new Pt();
            this._highlight = new Shape();
            return;
        }// end function

        override protected function onAdd() : void
        {
            super.onAdd();
            this.connectGrid();
            return;
        }// end function

        override protected function onRemove() : void
        {
            this.disConnectGrid();
            this._highlight = null;
            this.gridComponentReference = null;
            super.onRemove();
            return;
        }// end function

        override protected function onReset() : void
        {
            super.onReset();
            this.connectGrid();
            return;
        }// end function

        protected function connectGrid() : void
        {
            if (!this.grid)
            {
                return;
            }
            if (!this._connected)
            {
            }
            if (this._gridComp.displayObject)
            {
                this._gridComp.displayObject.cacheAsBitmap = true;
                this.addListeners();
                this._connected = true;
                this.addHighlightToScene();
            }
            return;
        }// end function

        protected function disConnectGrid() : void
        {
            if (!this._gridComp)
            {
                return;
            }
            this._connected = false;
            this.removeListeners();
            if (this._gridComp)
            {
            }
            if (this._gridComp.displayObject)
            {
                (this._gridComp.displayObject as Sprite).removeChild(this._highlight);
            }
            this._gridComp = null;
            return;
        }// end function

        protected function addListeners() : void
        {
            if (!this._gridComp)
            {
                return;
            }
            this._gridComp.displayObject.addEventListener(MouseEvent.MOUSE_MOVE, this.onMouseMoving, false, 0, true);
            this._gridComp.displayObject.addEventListener(DragEvent.DRAG_OVER, this.onMouseMoving, false, 0, true);
            this._gridComp.displayObject.addEventListener(DragEvent.DRAG_COMPLETE, this.clearHighlight, false, 0, true);
            this._gridComp.displayObject.addEventListener(DragEvent.DRAG_EXIT, this.clearHighlight, false, 0, true);
            this._gridComp.displayObject.addEventListener(MouseEvent.MOUSE_OUT, this.clearHighlight, false, 0, true);
            return;
        }// end function

        protected function removeListeners() : void
        {
            if (!this.grid)
            {
                return;
            }
            this._gridComp.displayObject.removeEventListener(MouseEvent.MOUSE_MOVE, this.onMouseMoving);
            this._gridComp.displayObject.removeEventListener(DragEvent.DRAG_OVER, this.onMouseMoving);
            this._gridComp.displayObject.removeEventListener(DragEvent.DRAG_COMPLETE, this.clearHighlight);
            this._gridComp.displayObject.removeEventListener(DragEvent.DRAG_EXIT, this.clearHighlight);
            this._gridComp.displayObject.removeEventListener(MouseEvent.MOUSE_OUT, this.clearHighlight);
            return;
        }// end function

        protected function onMouseMoving(event:MouseEvent) : void
        {
            event.stopImmediatePropagation();
            if (!this.enabled)
            {
                this.clearHighlight();
                return;
            }
            this.addHighlightToScene();
            if (this._cellSize != this.grid.cellSize)
            {
                this.drawHighlight();
            }
            var _loc_2:* = IsoUtils.mouseToIso(event.stageX, event.stageY, this._gridComp.scene);
            var _loc_3:* = Math.floor((_loc_2.x - this._gridComp.position.x) / this._cellSize) * this._cellSize;
            var _loc_4:* = Math.floor((_loc_2.y - this._gridComp.position.y) / this._cellSize) * this._cellSize;
            if (_loc_3 < 0)
            {
            }
            if (_loc_4 < 0)
            {
                this.clearHighlight();
                return;
            }
            if (this._currentGridX == _loc_3)
            {
            }
            if (this._currentGridY == _loc_4)
            {
                return;
            }
            this._highlight.visible = true;
            this._currentGridX = _loc_3;
            this._currentGridY = _loc_4;
            this.currentGridPoint.x = this._currentGridX;
            this.currentGridPoint.y = this._currentGridY;
            var _loc_5:* = IsoMath.isoToScreen(new Pt(this._currentGridX, this._currentGridY), true);
            this._highlight.x = _loc_5.x;
            this._highlight.y = _loc_5.y;
            this._highlight.graphics.endFill();
            return;
        }// end function

        protected function clearHighlight(event:MouseEvent = null) : void
        {
            if (event)
            {
                event.stopImmediatePropagation();
            }
            this._highlight.visible = false;
            return;
        }// end function

        protected function addHighlightToScene() : void
        {
            if (this.grid)
            {
            }
            if (!this._gridComp.displayObject)
            {
                return;
            }
            if ((this._gridComp.displayObject as Sprite).contains(this._highlight))
            {
                return;
            }
            (this._gridComp.displayObject as Sprite).addChild(this._highlight);
            this._highlight.visible = false;
            return;
        }// end function

        protected function drawHighlight() : void
        {
            if (!this.grid)
            {
                return;
            }
            this._cellSize = this.grid.cellSize;
            var _loc_1:* = this._highlight.graphics;
            _loc_1.clear();
            var _loc_2:* = IsoMath.isoToScreen(new Pt(0, 0, 0));
            var _loc_3:* = IsoMath.isoToScreen(new Pt(this._cellSize, 0, 0));
            var _loc_4:* = IsoMath.isoToScreen(new Pt(this._cellSize, this._cellSize, 0));
            var _loc_5:* = IsoMath.isoToScreen(new Pt(0, this._cellSize, 0));
            this._highlight.graphics.lineStyle(3, this.highlightColor, 0.7);
            this._highlight.graphics.beginFill(this.highlightColor, 0.5);
            _loc_1.moveTo(_loc_2.x, _loc_2.y);
            _loc_1.lineTo(_loc_3.x, _loc_3.y);
            _loc_1.lineTo(_loc_4.x, _loc_4.y);
            _loc_1.lineTo(_loc_5.x, _loc_5.y);
            _loc_1.lineTo(_loc_2.x, _loc_2.y);
            return;
        }// end function

        protected function get grid() : IsoGridComponent
        {
            if (!this.gridComponentReference)
            {
                this.disConnectGrid();
                return null;
            }
            if (!this._gridComp)
            {
                this._gridComp = owner.getProperty(this.gridComponentReference) as IsoGridComponent;
                this.drawHighlight();
            }
            return this._gridComp;
        }// end function

        public function get enabled() : Boolean
        {
            return this._enabled;
        }// end function

        public function set enabled(param1:Boolean) : void
        {
            this._enabled = param1;
            if (this._enabled == false)
            {
                this.removeListeners();
                this.clearHighlight(null);
            }
            else if (this._enabled == true)
            {
                this.addListeners();
            }
            return;
        }// end function

    }
}
