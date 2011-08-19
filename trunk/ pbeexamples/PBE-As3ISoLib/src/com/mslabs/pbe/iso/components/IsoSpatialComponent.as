package com.mslabs.pbe.iso.components
{
    import as3isolib.geom.*;
    import com.pblabs.engine.components.*;
    import com.pblabs.engine.core.*;
    import com.pblabs.rendering2D.*;
    import flash.geom.*;

    public class IsoSpatialComponent extends TickedComponent implements IIsoSpatialObject
    {
        private var _objectMask:ObjectType;
        private var _spatialManager:ISpatialManager2D;
        public var spriteForPointChecks:DisplayObjectRenderer;
        private var _position:Pt;
        private var _positionOffset:Pt;
        private var _rotation:Number = 0;
        private var _isometricVolume:Pt;
        public var velocity:Point;
        public var angularVelocity:Number = 0;

        public function IsoSpatialComponent()
        {
            this._position = new Pt(0, 0, 0);
            this._positionOffset = new Pt(0, 0, 0);
            this._isometricVolume = new Pt(100, 100, 100);
            this.velocity = new Point(0, 0);
            return;
        }// end function

        override public function onTick(param1:Number) : void
        {
            this._position.x = this._position.x + this.velocity.x * param1;
            this._position.y = this._position.y + this.velocity.y * param1;
            this.rotation = this.rotation + this.angularVelocity * param1;
            return;
        }// end function

        public function castRay(param1:Point, param2:Point, param3:ObjectType, param4:RayHitInfo) : Boolean
        {
            return false;
        }// end function

        public function pointOccupied(param1:Point, param2:ObjectType, param3:IScene2D) : Boolean
        {
            if (this.spriteForPointChecks)
            {
            }
            if (!param3)
            {
                return this.worldExtents.containsPoint(param1);
            }
            return this.spriteForPointChecks.pointOccupied(param3.transformWorldToScreen(param1), param2);
        }// end function

        override protected function onAdd() : void
        {
            super.onAdd();
            if (this._spatialManager)
            {
                this._spatialManager.addSpatialObject(this);
            }
            return;
        }// end function

        override protected function onRemove() : void
        {
            super.onRemove();
            if (this._spatialManager)
            {
                this._spatialManager.removeSpatialObject(this);
            }
            return;
        }// end function

        public function get spatialManager() : ISpatialManager2D
        {
            return this._spatialManager;
        }// end function

        public function set spatialManager(param1:ISpatialManager2D) : void
        {
            if (!isRegistered)
            {
                this._spatialManager = param1;
                return;
            }
            if (this._spatialManager)
            {
                this._spatialManager.removeSpatialObject(this);
            }
            this._spatialManager = param1;
            if (this._spatialManager)
            {
                this._spatialManager.addSpatialObject(this);
            }
            return;
        }// end function

        public function get position() : Pt
        {
            return this._position;
        }// end function

        public function set position(param1:Pt) : void
        {
            this._position = param1;
            return;
        }// end function

        public function get positionOffset() : Pt
        {
            return this._positionOffset as Pt;
        }// end function

        public function set positionOffset(param1:Pt) : void
        {
            this._positionOffset = param1;
            return;
        }// end function

        public function get rotation() : Number
        {
            return this._rotation;
        }// end function

        public function set rotation(param1:Number) : void
        {
            this._rotation = param1;
            return;
        }// end function

        public function get isometricVolume() : Pt
        {
            return this._isometricVolume;
        }// end function

        public function set isometricVolume(param1:Pt) : void
        {
            this._isometricVolume = param1;
            return;
        }// end function

        public function get objectMask() : ObjectType
        {
            return this._objectMask;
        }// end function

        public function set objectMask(param1:ObjectType) : void
        {
            this._objectMask = param1;
            return;
        }// end function

        public function get worldExtents() : Rectangle
        {
            return new Rectangle(this.position.x - this.isometricVolume.x * 0.5, this.position.y - this.isometricVolume.y * 0.5, this.isometricVolume.x, this.isometricVolume.y);
        }// end function

    }
}
