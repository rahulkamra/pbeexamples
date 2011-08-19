package com.mslabs.pbe.components
{
    import com.pblabs.engine.*;
    import com.pblabs.engine.components.*;
    import com.pblabs.engine.debug.*;
    import com.pblabs.engine.entity.*;
    import com.pblabs.engine.resource.*;
    import flash.events.*;
    import flash.utils.*;

    public class ResourceLoaderComponent extends TickedComponent
    {
        public var resource:Resource;
        protected var _fileName:String;
        protected var _compReference:PropertyReference;
        protected var _compProp:String;
        protected var _className:String;
        protected var _resourceType:String;
        protected var _resourceTypeClass:Class;
        protected var _alreadyUnloaded:Boolean = false;

        public function ResourceLoaderComponent()
        {
            return;
        }// end function

        override public function onTick(param1:Number) : void
        {
            super.onTick(param1);
            if (!owner)
            {
                return;
            }
            if (this._resourceType)
            {
            }
            if (this._fileName)
            {
                if (!this._resourceTypeClass)
                {
                    this._resourceTypeClass = getDefinitionByName(this._resourceType) as Class;
                }
                if (!PBE.resourceManager.isLoaded(this._fileName, this._resourceTypeClass))
                {
                    this._alreadyUnloaded = true;
                    owner.removeComponent(this);
                }
            }
            return;
        }// end function

        override protected function onAdd() : void
        {
            super.onAdd();
            this.loadResource();
            return;
        }// end function

        override protected function onRemove() : void
        {
            this.unLoadResource();
            super.onRemove();
            return;
        }// end function

        override protected function onReset() : void
        {
            super.onReset();
            return;
        }// end function

        protected function onResourceLoaded(param1:Resource) : void
        {
            if (!owner)
            {
                return;
            }
            if (param1)
            {
            }
            if (this.resource == null)
            {
                this.resource = param1;
                if (this.resource.isLoaded)
                {
                    owner.eventDispatcher.dispatchEvent(new Event("resourceLoaded"));
                }
            }
            return;
        }// end function

        protected function onResourceFailed(param1:Resource) : void
        {
            Logger.error(this, "onResourceFailed", "Failed to load \'" + (param1 ? (param1.filename) : ("(unknown)")) + "\'");
            return;
        }// end function

        protected function loadResource() : void
        {
            var _loc_1:Class = null;
            var _loc_2:Resource = null;
            if (!owner)
            {
                return;
            }
            if (this.resource)
            {
                return;
            }
            if (this._fileName)
            {
            }
            if (this._resourceType)
            {
                _loc_1 = Class(getDefinitionByName(this._resourceType));
                PBE.resourceManager.onlyLoadEmbeddedResources = true;
                _loc_2 = PBE.resourceManager.load(this._fileName, _loc_1, this.onResourceLoaded, this.onResourceFailed);
                this.onResourceLoaded(_loc_2);
            }
            return;
        }// end function

        protected function unLoadResource() : void
        {
            owner.eventDispatcher.dispatchEvent(new Event("resourceUnloaded"));
            if (!this._alreadyUnloaded)
            {
                PBE.resourceManager.unload(this._fileName, Class(getDefinitionByName(this._resourceType)));
            }
            return;
        }// end function

        public function get fileUrl() : String
        {
            return this._fileName;
        }// end function

        public function set fileUrl(param1:String) : void
        {
            this._fileName = param1;
            this.loadResource();
            return;
        }// end function

        public function get resourceType() : String
        {
            return this._resourceType;
        }// end function

        public function set resourceType(param1:String) : void
        {
            this._resourceType = param1;
            this.loadResource();
            return;
        }// end function

    }
}
