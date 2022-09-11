using Celeste;
using Celeste.Mod.Entities;
using FactoryHelper.Entities;
using Microsoft.Xna.Framework;
using Monocle;

namespace FactoryHelper.Triggers {
    [CustomEntity("FactoryHelper/SpecialBoxDeactivationTrigger")]
    public class SpecialBoxDeactivationTrigger : Trigger {
        public SpecialBoxDeactivationTrigger(EntityData data, Vector2 offset) : base(data, offset) {
            Add(new HoldableCollider(OnCollide));
        }

        private void OnCollide(Holdable holdable) {
            if (holdable.Entity is ThrowBox box) {
                box.StopBeingSpecial();
            }
        }

        public override void OnEnter(Player player) {
            base.OnEnter(player);
            if (player.Holding?.Entity is ThrowBox box) {
                box.StopBeingSpecial();
            }
        }
    }
}
