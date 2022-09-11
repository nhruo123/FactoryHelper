using Celeste;
using Celeste.Mod;
using Microsoft.Xna.Framework;
using System.Collections.Generic;

namespace FactoryHelper {
    public class FactoryHelperSession : EverestModuleSession {
        public HashSet<EntityID> Batteries = new();
        public HashSet<EntityID> PermanentlyRemovedActivatorDashBlocks = new();
        public Vector2? SpecialBoxPosition;
        public Session OriginalSession;
        public string SpecialBoxLevel;
    }
}