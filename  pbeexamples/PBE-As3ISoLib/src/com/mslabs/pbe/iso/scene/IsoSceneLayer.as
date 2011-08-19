package com.mslabs.pbe.iso.scene
{
    import as3isolib.data.*;
    import as3isolib.display.*;
    import as3isolib.display.scene.*;
    import as3isolib.geom.*;
    
    import com.mslabs.pbe.iso.components.*;
    import com.mslabs.pbe.iso.renderers.*;
    import com.pblabs.engine.*;
    import com.pblabs.engine.core.ITickedObject;
    import com.pblabs.engine.debug.*;
    import com.pblabs.engine.entity.*;
    import com.pblabs.rendering2D.*;
    import com.pblabs.rendering2D.ui.*;
    
    import flash.display.*;
    import flash.geom.*;
    import flash.utils.*;

    public class IsoSceneLayer extends DisplayObjectScene implements ITickedObject
    {
        protected var _isoScene:IsoScene;
        protected var _layoutRenderer:IIsoCustomRenderer;
        protected var _localDisplayContainer:DisplayObjectContainer;
        public var displayObjectContainerProperty:PropertyReference;
        public static const COMPONENT_NAME:String = getQualifiedClassName(IsoSceneLayer).replace("::", ".");

        public function IsoSceneLayer()
        {
            updatePriority = -10;
            this._isoScene = new IsoScene();
            return;
        }// end function

        public function onTick(param1:Number) : void
        {
            this.renderScene();
            return;
        }// end function

        public function renderScene() : void
        {
            this._isoScene.render(true);
            if (_sceneView)
            {
                if (!IsoSceneView(_sceneView).scenes.length < 1)
                {
                    return;
                }
                if (IsoSceneView(_sceneView).scenes[0] == this._isoScene)
                {
                    IsoSceneView(_sceneView).render();
                }
            }
            return;
        }// end function

        override public function add(param1:DisplayObjectRenderer) : void
        {
            if (param1 is IIsoComponent)
            {
                if (param1.displayObject)
                {
                    _renderers[param1.displayObject] = param1;
                }
                this.addIsoComponent(IIsoComponent(param1).isoComponent);
            }
            else
            {
                Logger.error(this, "add", "you can not add a non IIsoComponent to this type of Scene");
            }
            return;
        }// end function

        override public function remove(param1:DisplayObjectRenderer) : void
        {
            if (param1 is IIsoComponent)
            {
                if (param1.displayObject)
                {
                    delete _renderers[param1.displayObject];
                }
                this.removeIsoComponent(IIsoComponent(param1).isoComponent);
            }
            else
            {
                Logger.error(this, "remove", "you can not remove a non IIsoComponent from this Scene. There should not have been an non IIsoComponent added.");
            }
            return;
        }// end function

        override public function screenPan(param1:int, param2:int) : void
        {
            if (_sceneView)
            {
                IsoSceneView(_sceneView).pan(param1, param2);
            }
            else
            {
                super.screenPan(param1, param2);
            }
            return;
        }// end function

        override public function updateTransform() : void
        {
            if (!sceneView)
            {
                return;
            }
            if (_transformDirty == false)
            {
                return;
            }
            _transformDirty = false;
            _rootSprite.rotation = _rootRotation;
            SceneAlignment.calculate(_tempPoint, sceneAlignment, sceneView.width, sceneView.height);
            _rootSprite.x = _rootPosition.x;
            _rootSprite.y = _rootPosition.y;
            return;
        }// end function

        override public function sortSpatials(param1:Array) : void
        {
            trace("sortSpatials(array) - Sorting of Isometric Objects is handled by the layoutRenderer of the scene");
            return;
        }// end function

        override public function onFrame(param1:Number) : void
        {
            var _loc_2:Pt = null;
            var _loc_3:Rectangle = null;
            if (!sceneView)
            {
                Logger.warn(this, "onFrame", "sceneView is null, so we aren\'t rendering.");
                return;
            }
            if (!trackObject is IIsoComponent)
            {
                Logger.error(this, "onFrame", "The tracked Object must be an IIsoComponent");
                return;
            }
            if (trackObject)
            {
                _loc_2 = IIsoComponent(trackObject).isoComponent.isoBounds.centerPt;
                _loc_2.x = _loc_2.x + this.trackOffset.x;
                _loc_2.y = _loc_2.y + this.trackOffset.y;
                IsoSceneView(this._sceneView).centerOnPt(_loc_2);
            }
            if (trackLimitRectangle != null)
            {
                _loc_3 = new Rectangle(trackLimitRectangle.x + sceneView.width * 0.5, trackLimitRectangle.y + sceneView.height * 0.5, trackLimitRectangle.width - sceneView.width, trackLimitRectangle.height - sceneView.height);
                _loc_2 = new Pt(PBUtil.clamp(IsoSceneView(this._sceneView).currentX + this.trackOffset.x, -_loc_3.right, -_loc_3.left), PBUtil.clamp(IsoSceneView(this._sceneView).currentY + this.trackOffset.y, -_loc_3.bottom, -_loc_3.top));
                IsoSceneView(this._sceneView).centerOnPt(_loc_2, false);
            }
            return;
        }// end function

        override public function transformScreenToWorld(param1:Point) : Point
        {
            this.updateTransform();
            return IsoMath.screenToIso(new Pt(param1.x, param1.y));
        }// end function

        override public function transformWorldToScreen(param1:Point) : Point
        {
            this.updateTransform();
            return IsoMath.isoToScreen(param1 as Pt);
        }// end function

        public function getBounds(param1:DisplayObject) : Rectangle
        {
            return this._isoScene.container.getBounds(param1);
        }// end function

        protected function addIsoComponent(param1:INode) : void
        {
            if (this._isoScene)
            {
                this._isoScene.addChild(param1);
                this._isoScene.render();
            }
            return;
        }// end function

        protected function removeIsoComponent(param1:INode) : void
        {
            if (this._isoScene)
            {
                this._isoScene.removeChild(param1);
            }
            return;
        }// end function

        override protected function onAdd() : void
        {
            this._layoutRenderer = new IsoSceneLayoutRenderer();
            this._isoScene.layoutRenderer = this._layoutRenderer;
            _rootSprite = this._isoScene.container;
            super.onAdd();
            PBE.processManager.addTickedObject(this);
            return;
        }// end function

        override protected function onRemove() : void
        {
            this._isoScene.removeAllChildren();
            this._isoScene.hostContainer = null;
            this._rootSprite = null;
            this.displayContainer = null;
            this.displayObjectContainerProperty = null;
            if (this._layoutRenderer != null)
            {
                this._layoutRenderer.destroy();
                this.layoutRenderer = null;
            }
            this._isoScene.removeAllChildren();
            IsoView(this._sceneView).removeScene(this._isoScene);
            this._isoScene = null;
            this._sceneView = null;
            super.onRemove();
            PBE.processManager.removeTickedObject(this);
            return;
        }// end function

        override protected function onReset() : void
        {
            super.onReset();
            if (this._isoScene.hostContainer != null)
            {
                this._isoScene.hostContainer = null;
            }
            this._isoScene.invalidateScene();
            return;
        }// end function

        public function get layoutEnabled() : Boolean
        {
            return this._isoScene.layoutEnabled;
        }// end function

        public function set layoutEnabled(param1:Boolean) : void
        {
            this._isoScene.layoutEnabled = param1;
            return;
        }// end function

        public function set layoutRenderer(param1:IIsoCustomRenderer) : void
        {
            if (this._layoutRenderer != null)
            {
                this._layoutRenderer.destroy();
            }
            this._layoutRenderer = param1;
            this._isoScene.layoutRenderer = this._layoutRenderer;
            return;
        }// end function

        public function get stylingEnabled() : Boolean
        {
            return this._isoScene.stylingEnabled;
        }// end function

        public function set stylingEnabled(param1:Boolean) : void
        {
            this._isoScene.stylingEnabled = param1;
            return;
        }// end function

        public function get styleRenderers() : Array
        {
            return this._isoScene.styleRenderers;
        }// end function

        public function set styleRenderers(param1:Array) : void
        {
            this._isoScene.styleRenderers = param1;
            return;
        }// end function

        override public function set zoom(param1:Number) : void
        {
            super.zoom = param1;
            return;
        }// end function

        override public function set sceneView(param1:IUITarget) : void
        {
            if (!param1)
            {
                return;
            }
            if (!param1 is IsoSceneView)
            {
                Logger.warn(this, "sceneView", "You should only use an IsoSceneView with this type of component");
            }
            this.isoSceneView = param1 as IsoSceneView;
            return;
        }// end function

        public function set isoSceneView(param1:IsoSceneView) : void
        {
            _sceneView = param1;
            _sceneViewName = param1.name;
            param1.addScene(this._isoScene);
            return;
        }// end function

        public function get displayContainer() : DisplayObjectContainer
        {
            if (this.displayObjectContainerProperty != null)
            {
                return owner.getProperty(this.displayObjectContainerProperty) as DisplayObjectContainer;
            }
            return this._localDisplayContainer;
        }// end function

        public function set displayContainer(param1:DisplayObjectContainer) : void
        {
            this._localDisplayContainer = param1;
            if (this._localDisplayContainer != null)
            {
                this._isoScene.hostContainer = this._localDisplayContainer;
            }
            return;
        }// end function

        public static function getFrom(param1:IEntity) : IsoSceneLayer
        {
            return param1.lookupComponentByName(COMPONENT_NAME) as IsoSceneLayer;
        }// end function

    }
}
