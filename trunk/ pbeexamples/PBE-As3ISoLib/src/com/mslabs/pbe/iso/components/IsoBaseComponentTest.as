package com.mslabs.pbe.iso.components
{
    import as3isolib.geom.*;
    import com.pblabs.engine.entity.*;
    import flash.display.*;

    public class IsoBaseComponentTest extends Sprite
    {
        private var testClass:IsoBoxComponent;
        private var player:IEntity;

        public function IsoBaseComponentTest()
        {
            return;
        }// end function

        public function setUp() : void
        {
            this.testClass = new IsoBoxComponent();
            this.testClass.registerForUpdates = false;
            return;
        }// end function

        public function tearDown() : void
        {
            this.testClass = null;
            return;
        }// end function

        public function testPosition_And_PositionOffset_Property_Types() : void
        {
           // Assert.assertTrue("The Position property of the IsoBaseComponent needs to be re-Initialized with type as3isolib.geom.Pt ", this.testClass.position is Pt);
           // Assert.assertTrue("The PositionOffset property of the IsoBaseComponent needs to be re-Initialized with type as3isolib.geom.Pt ", this.testClass.position is Pt);
            return;
        }// end function

        public function testGet_isoComponent() : void
        {
           // Assert.assertNotNull("IsoObject should not be null", this.testClass.isoComponent);
            return;
        }// end function

        public function testSet_isoComponent() : void
        {
           // Assert.fail("Test method Not yet implemented");
            return;
        }// end function

        public static function setUpBeforeClass() : void
        {
            return;
        }// end function

        public static function tearDownAfterClass() : void
        {
            return;
        }// end function

    }
}
