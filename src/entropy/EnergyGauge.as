package entropy {
	import flash.display.Shape;
	
	/**
	 * @author player_03
	 */
	public class EnergyGauge extends Shape {
		private var mEnergyLevel:Number = 0;
		private var maxEnergy:Number;
		
		private var rectWidth:Number;
		private var rectHeight:Number;
		
		public function EnergyGauge(rectWidth:Number, rectHeight:Number,
									initialEnergy:Number, maxEnergy:Number) {
			super();
			
			this.rectWidth = rectWidth;
			this.rectHeight = rectHeight;
			this.maxEnergy = maxEnergy;
			
			energyLevel = initialEnergy;
		}
		
		public function addEnergy(energy:Number):void {
			energyLevel += energy;
		}
		
		public function get energyPercent():Number {
			return energyLevel / maxEnergy;
		}
		
		public function get energyLevel():Number {
			return mEnergyLevel;
		}
		
		public function set energyLevel(value:Number):void {
			if(value > maxEnergy) {
				mEnergyLevel = maxEnergy;
			} else if(value < 0) {
				mEnergyLevel = 0;
			} else {
				mEnergyLevel = value;
			}
			
			graphics.clear();
			graphics.lineStyle();
			graphics.beginFill(0x000000);
			graphics.drawRect(0, 0, rectWidth, rectHeight);
			graphics.endFill();
			
			graphics.beginFill(0x00FFFF);
			graphics.drawRect(0, 0, rectWidth * energyPercent, rectHeight);
			graphics.endFill();
			
			graphics.lineStyle(2, 0x008000);
			graphics.drawRect(0, 0, rectWidth, rectHeight);
		}
	}
}