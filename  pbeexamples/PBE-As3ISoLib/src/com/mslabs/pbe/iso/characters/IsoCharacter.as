package com.mslabs.pbe.iso.characters
{
    import com.mslabs.pbe.iso.characters.*;
    import com.mslabs.pbe.iso.components.*;
    import com.pblabs.rendering2D.spritesheet.*;

    public class IsoCharacter extends IsoSpriteSheetComponent implements IIsoCharacter
    {
        protected var _spirteSheetDivider:ISpriteSheetDivider;
        public static const SWF_SHEET_CHARACTER:String = "swf";
        public static const SPRITE_SHEET_CHARACTER:String = "image";

        public function IsoCharacter(param1:Boolean = false)
        {
            super(param1);
            return;
        }// end function

        override protected function onRemove() : void
        {
            super.onRemove();
            return;
        }// end function

        public function set spirteSheetDivider(param1:ISpriteSheetDivider) : void
        {
            if (this._spirteSheetDivider == param1)
            {
                return;
            }
            if (this._spirteSheetDivider)
            {
            }
            this._spirteSheetDivider = param1;
            return;
        }// end function

        public static function create(param1:String = "image", param2:Boolean = false) : IIsoCharacter
        {
            var _loc_4:SpriteSheetComponent = null;
            var _loc_3:* = new IsoCharacter;
            if (!param2)
            {
                _loc_4 = new SpriteSheetComponent();
                _loc_3.spriteSheet = _loc_4;
            }
            return _loc_3;
        }// end function

    }
}
