package com.mslabs.pbe.iso.scene
{
    import as3isolib.display.*;
    import as3isolib.display.scene.*;
    import as3isolib.geom.*;
    
    import com.pblabs.engine.*;
    import com.pblabs.rendering2D.ui.IUITarget;
    
    import flash.display.*;
    import flash.geom.*;

    public class IsoSceneView extends IsoView implements IUITarget
    {
        protected var _isoView:IsoView;
        protected var _bgPos:Point;
        protected var _fgPos:Point;

        public function IsoSceneView()
        {
            if (PBE.mainClass)
            {
                if (!PBE.mainClass.contains(this))
                {
                    PBE.mainClass.addChild(this);
                }
                setSize(PBE.mainStage.stage.stageWidth, PBE.mainStage.stage.stageHeight);
                name = "IsoSceneView";
            }
            return;
        }// end function

        public function getSceneIndex(param1:IIsoScene) : int
        {
            var _loc_2:uint = 0;
            var _loc_3:* = scenesArray.length;
            while (_loc_2 < _loc_3)
            {
                
                if (param1 == scenesArray[_loc_2])
                {
                    return _loc_2;
                }
                _loc_2 = _loc_2 + 1;
            }
            return -1;
        }// end function

        public function transformScreenToWorld(param1:Point) : Point
        {
            return IsoMath.screenToIso(new Pt(param1.x, param1.y));
        }// end function

        public function addDisplayObject(param1:DisplayObject) : void
        {
            mContainer.addChild(param1);
            return;
        }// end function

        public function clearDisplayObjects() : void
        {
            while (mContainer.numChildren)
            {
                
                mContainer.removeChildAt(0);
            }
            return;
        }// end function

        public function removeDisplayObject(param1:DisplayObject) : void
        {
            mContainer.removeChild(param1);
            return;
        }// end function

        public function setDisplayObjectIndex(param1:DisplayObject, param2:int) : void
        {
            mContainer.setChildIndex(param1, param2);
            return;
        }// end function

        override public function get width() : Number
        {
            return super.width;
        }// end function

        override public function set width(param1:Number) : void
        {
            return;
        }// end function

        override public function get height() : Number
        {
            return super.height;
        }// end function

        override public function set height(param1:Number) : void
        {
            return;
        }// end function

        public function get backgroundPosition() : Point
        {
            if (!this._bgPos)
            {
                this._bgPos = new Point();
                this._bgPos.x = this.backgroundContainer.x;
                this._bgPos.y = this.backgroundContainer.y;
            }
            return this._bgPos;
        }// end function

        public function set backgroundPosition(param1:Point) : void
        {
            this._bgPos = param1;
            this.backgroundContainer.x = this._bgPos.x;
            this.backgroundContainer.y = this._bgPos.y;
            return;
        }// end function

        public function get foregroundPosition() : Point
        {
            if (!this._fgPos)
            {
                this._fgPos = new Point();
                this._fgPos.x = this.foregroundContainer.x;
                this._fgPos.y = this.foregroundContainer.y;
            }
            return this._fgPos;
        }// end function

        public function set foregroundPosition(param1:Point) : void
        {
            this._fgPos = param1;
            this.foregroundContainer.x = this._fgPos.x;
            this.foregroundContainer.y = this._fgPos.y;
            return;
        }// end function

        public function get viewPosition() : Point
        {
            return targetScreenPt as Point;
        }// end function

        public function set viewPosition(param1:Point) : void
        {
            pan(param1.x, param1.y);
            return;
        }// end function

    }
}
