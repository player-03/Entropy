package entropy {
	import flash.geom.Point;
	import org.flintparticles.common.actions.ActionBase;
	import org.flintparticles.common.activities.FrameUpdatable;
	import org.flintparticles.common.activities.UpdateOnFrame;
	import org.flintparticles.common.particles.Particle;
	import org.flintparticles.common.emitters.Emitter;
	import org.flintparticles.twoD.actions.Friction;
	import org.flintparticles.twoD.particles.Particle2D;
	
	/**
	 * @author player_03
	 */
	public class TurbineCollider extends ActionBase implements FrameUpdatable {
		private var direction:Point;
		private var spin:Number = 0;
		private var minSpin:Number;
		private var maxSpin:Number;
		
		private var addEnergyCallback:Function;
		private var updateActivity:UpdateOnFrame;
		
		/**
		 * The particle's velocity, projected onto the direction vector.
		 */
		private var velocityInDirection:Point = new Point();
		
		public function TurbineCollider(direction:Point,
							addEnergyCallback:Function, maxSpin:Number = 10) {
			super();
			
			if(Math.abs(1 - (direction.x * direction.x + direction.y * direction.y)) > 0.0000001) {
				trace(direction);
				direction.normalize(1);
			}
			
			this.direction = direction;
			this.minSpin = -maxSpin;
			this.maxSpin = maxSpin;
			
			this.addEnergyCallback = addEnergyCallback;
		}
		
		public override function addedToEmitter(emitter:Emitter):void {
			if(updateActivity == null) {
				updateActivity = new UpdateOnFrame(this);
			}
			emitter.addActivity(updateActivity);
		}
		
		public override function removedFromEmitter(emitter:Emitter):void {
			if(updateActivity != null) {
				emitter.removeActivity(updateActivity);
			}
		}
		
		public function frameUpdate(emitter:Emitter, time:Number):void {
			//tweak these multipliers until things seem to work about right
			//if(spin != 0) {
			//	trace(spin);
			//}
			if(Math.abs(spin) > 2) {
				addEnergyCallback((Math.abs(spin) - 1.8) * time * 0.4);
			}
			spin -= spin * time * 0.25;
			if(spin > 0.1) {
				spin -= time * 0.15;
			} else if(spin < -0.1) {
				spin += time * 0.15;
			} else {
				spin = 0;
			}
		}
		
		public override function update(emitter:Emitter, particle:Particle, time:Number):void {
			var p:Particle2D = Particle2D(particle);
			
			//project the particle's velocity onto the direction vector
			var dot:Number = p.velX * direction.x + p.velY * direction.y;
			velocityInDirection.x = dot * direction.x;
			velocityInDirection.y = dot * direction.y;
			
			if(velocityInDirection.x * velocityInDirection.x
				+ velocityInDirection.y * velocityInDirection.y < 16) {
				return;
			}
			
			var speedInDirection:Number = velocityInDirection.length;
			spin += speedInDirection * time * 0.1 * (dot < 0 ? -1 : 1);
			
			//energy is wasted if the turbine is already spinning fast enough
			if(spin > maxSpin) {
				spin = maxSpin;
			} else if(spin < minSpin) {
				spin = minSpin;
			}
			
			p.velX -= velocityInDirection.x * speedInDirection * time * 0.01;
			p.velY -= velocityInDirection.y * speedInDirection * time * 0.01;
		}
	}
}