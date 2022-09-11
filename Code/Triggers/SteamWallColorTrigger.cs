using Celeste;
using Celeste.Mod.Entities;
using FactoryHelper.Entities;
using Microsoft.Xna.Framework;
using Monocle;
using System;

namespace FactoryHelper.Triggers {
    [CustomEntity("FactoryHelper/SteamWallColorTrigger")]
    public class SteamWallColorTrigger : Trigger {
        public float duration;

        private Color overrideColor = Color.White;

        public SteamWallColorTrigger(EntityData data, Vector2 offset) 
            : base(data, offset) {
            overrideColor = Calc.HexToColor(data.Attr("color", defaultValue: "ffffff"));
            duration = Math.Abs(data.Float("duration", defaultValue: 1f));
        }

        public override void OnEnter(Player player) {
            base.OnEnter(player);
            Level level = Scene as Level;
            SteamWall steamWall = level.Tracker.GetEntity<SteamWall>();
            if (steamWall != null) {
                steamWall.ColorShift(steamWall.color, overrideColor, duration);
            }
        }
    }
}