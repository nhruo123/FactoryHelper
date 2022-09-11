using Celeste;
using Celeste.Mod.Entities;
using FactoryHelper.Components;
using Microsoft.Xna.Framework;
using Monocle;
using System;
using System.Collections;
using System.Collections.Generic;

namespace FactoryHelper.Entities {
    [CustomEntity("FactoryHelper/ThrowBoxSpawner")]
    public class ThrowBoxSpawner : Entity {
        public FactoryActivator Activator;

        private readonly float _delay;
        private readonly int _maximum;
        private readonly bool _isMetal;
        private readonly bool _isRandom;
        private readonly HashSet<ThrowBox> _boxes = new();
        private readonly bool _fromTop;
        private readonly bool _tutorial;

        public ThrowBoxSpawner(Vector2 position, float delay, int maximum, string activationId, bool isMetal, bool isRandom, bool fromTop, bool tutorial, bool startActive) : base(position) {
            Add(Activator = new FactoryActivator());
            Activator.ActivationId = activationId == string.Empty ? null : activationId;
            Activator.StartOn = startActive;

            Collider = new Hitbox(16, 16);

            _maximum = maximum;
            _delay = delay;
            _isMetal = isMetal;
            _isRandom = isRandom;
            _fromTop = fromTop;
            _tutorial = tutorial;
            Add(new Coroutine(SpawnSequence()));
            Add(new SteamCollider(OnSteamWall));
        }

        public ThrowBoxSpawner(EntityData data, Vector2 offset)
            : this(data.Position + offset, data.Float("delay", 5f), data.Int("maximum", 0), data.Attr("activationId"), data.Bool("isMetal", false),
                   data.Bool("isRandom", false), data.Bool("fromTop", true), data.Bool("tutorial", false), data.Bool("startActive", true)) {
        }

        private void OnSteamWall(SteamWall steamWall) {
            Activator.ForceDeactivate();
        }

        public override void Added(Scene scene) {
            base.Added(scene);
            Activator.HandleStartup(scene);
        }

        private IEnumerator SpawnSequence() {
            while (true) {
                if (Activator.IsOn) {
                    yield return _delay;
                    TrySpawnThrowBox();
                } else {
                    yield return null;
                }
            }
        }

        private void TrySpawnThrowBox() {
            if (_maximum <= 0 || _boxes.Count < _maximum) {
                float posY = _fromTop ? SceneAs<Level>().Bounds.Top - 15 : Position.Y;
                float posX = _fromTop ? Position.X : GetClosestPositionH();
                ThrowBox crate = new(
                    position: new Vector2(posX, posY),
                    isMetal: _isRandom ? Calc.Random.Chance(0.5f) : _isMetal,
                    tutorial: _tutorial
                    );
                Scene.Add(crate);
                _boxes.Add(crate);
                crate.OnRemoved = () => _boxes.Remove(crate);
            }
        }

        private float GetClosestPositionH() {
            Level level = SceneAs<Level>();
            return Math.Abs(Left - level.Bounds.Left) < Math.Abs(Right - level.Bounds.Right) ? level.Bounds.Left - 15f : level.Bounds.Right - 1f;
        }
    }
}
