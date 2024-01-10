using Celeste;
using Celeste.Mod.Entities;
using FactoryHelper.Components;
using Microsoft.Xna.Framework;
using Monocle;
using System;
using System.Collections.Generic;
using System.Linq;

namespace FactoryHelper.Entities {
    [CustomEntity("FactoryHelper/WindTunnel")]
    public class WindTunnel : Entity {
        private static readonly float _baseAlpha = 0.7f;
        private static readonly char[] separators = { ',' };

        private readonly float _windUpTime = 0.5f;
        private readonly float _windDownTime = 0.2f;
        private readonly Dictionary<WindMover, float> _componentPercentages = new();
        private readonly float _loopWidth;
        private readonly float _loopHeight;
        private readonly float _strength;
        private readonly Direction _direction;
        private readonly Particle[] _particles;
        private Vector2 _scale = Vector2.One;
        private float _percent;
        private bool _speedingUp;
        private Vector2 _defaultWindSpeed;
        private Color[] _colors;

        public WindTunnel(Vector2 position, int width, int height, float strength, string direction, string activationId, bool startActive,
            string particleColors, bool showParticles) {
            Depth = -1000;
            Position = position;
            _loopWidth = width;
            _loopHeight = height;

            Add(Activator = new FactoryActivator());
            Activator.ActivationId = activationId == string.Empty ? null : activationId;
            Activator.StartOn = startActive;
            Activator.OnTurnOn = () => {
                _speedingUp = true;
            };
            Activator.OnTurnOff = () => {
                _speedingUp = false;
            };
            Activator.OnStartOff = () => {
                _percent = 0f;
                _speedingUp = false;
            };
            Activator.OnStartOn = () => {
                _percent = 1f;
                _speedingUp = true;
            };

            Add(new SteamCollider(OnSteamWall));

            Collider = new Hitbox(width, height);
            _strength = strength;
            Enum.TryParse(direction, out _direction);

            switch (_direction) {
                case Direction.Up:
                    _defaultWindSpeed = -Vector2.UnitY * _strength;
                    break;
                case Direction.Down:
                    _defaultWindSpeed = Vector2.UnitY * _strength;
                    break;
                case Direction.Left:
                    _defaultWindSpeed = -Vector2.UnitX * _strength;
                    break;
                case Direction.Right:
                    _defaultWindSpeed = Vector2.UnitX * _strength;
                    break;
            }

            int particlecount = showParticles ? width * height / 300 : 0;

            _colors = particleColors.Split(separators, StringSplitOptions.RemoveEmptyEntries)
                .Select(str => Calc.HexToColor(str.Trim()))
                .ToArray();

            _particles = new Particle[particlecount];
            for (int i = 0; i < _particles.Length; i++) {
                Reset(i, Calc.Random.NextFloat(_baseAlpha));
            }
        }

        public WindTunnel(EntityData data, Vector2 offset)
            : this(data.Position + offset, data.Width, data.Height, data.Float("strength", 1f), data.Attr("direction", "Up"), data.Attr("activationId", ""),
                   data.Bool("startActive", false), data.Attr("particleColors", "808080,545151,ada5a5"), data.Bool("showParticles", true)) {
        }

        public enum Direction {
            Up,
            Down,
            Left,
            Right
        }

        public FactoryActivator Activator { get; }

        private Vector2 _actualWindSpeed => _defaultWindSpeed * _percent;

        private void OnSteamWall(SteamWall obj) {
            Activator.ForceDeactivate();
        }

        public override void Added(Scene scene) {
            base.Added(scene);
            Activator.HandleStartup(scene);
            PositionParticles();
        }

        public override void Update() {
            if (_speedingUp && (_percent < 1f)) {
                _percent = Calc.Approach(_percent, 1f, Engine.DeltaTime / 1f);
            } else if (!_speedingUp && (_percent > 0f)) {
                _percent = Calc.Approach(_percent, 0f, Engine.DeltaTime / 1.5f);
            }

            PositionParticles();
            foreach (WindMover component in Scene.Tracker.GetComponents<WindMover>()) {
                if (component.Entity.CollideCheck(this)) {
                    if (_componentPercentages.ContainsKey(component)) {
                        _componentPercentages[component] = Calc.Approach(_componentPercentages[component], 1f, Engine.DeltaTime / _windUpTime);
                    } else {
                        _componentPercentages.Add(component, 0f);
                    }
                } else {
                    if (_componentPercentages.ContainsKey(component)) {
                        _componentPercentages[component] = Calc.Approach(_componentPercentages[component], 0.0f, Engine.DeltaTime / _windDownTime);
                        if (_componentPercentages[component] == 0f) {
                            _componentPercentages.Remove(component);
                        }
                    }
                }
            }

            foreach (WindMover component in _componentPercentages.Keys) {
                if (component != null && component.Entity != null && component.Entity.Scene != null) {
                    component.Move(_actualWindSpeed * 0.1f * Engine.DeltaTime * Ease.CubeInOut(_componentPercentages[component]));
                }
            }

            base.Update();
        }

        public override void Render() {
            for (int i = 0; i < _particles.Length; i++) {
                Vector2 particlePosition = default;
                particlePosition.X = Mod(_particles[i].Position.X, _loopWidth);
                particlePosition.Y = Mod(_particles[i].Position.Y, _loopHeight);
                float percent = _particles[i].Percent;
                float num = (!(percent < 0.7f)) ? Calc.ClampedMap(percent, 0.7f, 1f, 1f, 0f) : Calc.ClampedMap(percent, 0f, 0.3f);
                Draw.Rect(particlePosition + Position, _scale.X, _scale.Y, _colors[_particles[i].Color] * num);
            }
        }

        private void PositionParticles() {
            bool flag = _actualWindSpeed.Y == 0f;
            Vector2 zero;
            if (flag) {
                _scale.X = Math.Max(1f, Math.Abs(_actualWindSpeed.X) / 40f);
                _scale.Y = 1f;
                zero = new Vector2(_actualWindSpeed.X, 0f);
            } else {
                float divisor = _direction == Direction.Down ? 20f : 100f;
                _scale.X = 1f;
                _scale.Y = Math.Max(1f, Math.Abs(_actualWindSpeed.Y) / divisor);
                zero = new Vector2(0f, _actualWindSpeed.Y * 2f);
            }

            for (int i = 0; i < _particles.Length; i++) {
                if (_particles[i].Percent >= 1f) {
                    Reset(i, 0f);
                }

                float divisor = _direction switch {
                    Direction.Up => 4f,
                    Direction.Down => 1.5f,
                    _ => 1f,
                };
                _particles[i].Percent += Engine.DeltaTime / _particles[i].Duration;
                _particles[i].Position += ((_particles[i].Direction * _particles[i].Speed) + (zero / divisor)) * Engine.DeltaTime;
                _particles[i].Direction.Rotate(_particles[i].Spin * Engine.DeltaTime);
            }
        }

        private float Mod(float x, float m) {
            return ((x % m) + m) % m;
        }

        private void Reset(int i, float p) {
            _particles[i].Percent = p;
            _particles[i].Position = new Vector2(Calc.Random.Range(0, _loopWidth), Calc.Random.Range(0, _loopHeight));
            _particles[i].Speed = Calc.Random.Range(4, 14);
            _particles[i].Spin = Calc.Random.Range(0.25f, (float)Math.PI * 6f);
            _particles[i].Duration = Calc.Random.Range(1f, 4f);
            _particles[i].Direction = Calc.AngleToVector(Calc.Random.NextFloat((float)Math.PI * 2f), 1f);
            _particles[i].Color = Calc.Random.Next(_colors.Length);
        }

        public struct Particle {
            public Vector2 Position;
            public float Percent;
            public float Duration;
            public Vector2 Direction;
            public float Speed;
            public float Spin;
            public int Color;
        }
    }
}
