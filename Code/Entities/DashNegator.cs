using Celeste;
using Celeste.Mod.Entities;
using FactoryHelper.Components;
using Microsoft.Xna.Framework;
using Monocle;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Linq;

namespace FactoryHelper.Entities {


    [CustomEntity("FactoryHelper/DashNegator")]
    public class DashNegator : Entity {
        public enum ActivationCondition {
            OnDash = 0,
            IsDashing = 1,
            IsNotDashing = 2,
        }
        public enum Direction {
            Down = 0,
            Left = 1,
            Right = 2,
        }

        public static readonly ParticleType P_NegatorField = new() {
            Size = 1f,
            Color = Calc.HexToColor("800000") * 0.8f,
            Color2 = Calc.HexToColor("c40000") * 0.8f,
            ColorMode = ParticleType.ColorModes.Static,
            FadeMode = ParticleType.FadeModes.InAndOut,
            SpeedMin = 4f,
            SpeedMax = 8f,
            SpinMin = 0.002f,
            SpinMax = 0.005f,
            Acceleration = Vector2.Zero,
            DirectionRange = (float)Math.PI * 2f,
            Direction = 0f,
            LifeMin = 1.5f,
            LifeMax = 2.5f
        };

        public FactoryActivator Activator;

        private static int TEXTURE_HIGHT;
        private static int TEXTURE_WIDTH;

        static DashNegator() {
            MTexture texture = GFX.Game["danger/FactoryHelper/dashNegator/"];
            TEXTURE_WIDTH = texture.Width;
            TEXTURE_HIGHT = texture.Height;
        }

        private readonly Direction _direction;
        private readonly Sprite[] _turretSprites;
        private readonly Solid[] _turretSolids;
        private readonly float _particleSpanPeriod;
        private ActivationCondition _activationCondition;

        private readonly SortedDictionary<string, (bool, ActivationCondition)> _activationConditionControls = new SortedDictionary<string, (bool, ActivationCondition)>();
        private readonly List<String> _activationConditionControlsOrder = new List<string>();

        public DashNegator(Vector2 position,
                           int width,
                           int height,
                           string activationId,
                           bool startActive,
                           ActivationCondition activationCondition,
                           Direction direction,
                           bool enableCollision,
                           string activationConditionControlls)
            : base(position) {
            Add(Activator = new FactoryActivator());
            Activator.ActivationId = activationId == string.Empty ? null : activationId;
            Activator.StartOn = startActive;
            Activator.OnStartOff = OnStartOff;
            Activator.OnStartOn = OnStartOn;
            Activator.OnTurnOff = OnTurnOff;
            Activator.OnTurnOn = OnTurnOn;

            this._direction = direction;

            Add(new SteamCollider(OnSteamWall));

            this._activationCondition = activationCondition;

            int turretCount;
            if (direction == Direction.Down) {
                width = TEXTURE_WIDTH * (width / TEXTURE_WIDTH);
                Collider = new Hitbox(width - 4, height, 2, 0);
                turretCount = width / TEXTURE_WIDTH;
            } else {
                height = TEXTURE_HIGHT * (height / TEXTURE_HIGHT);
                Collider = new Hitbox(width, height - 4, 0, 2);
                turretCount = height / TEXTURE_HIGHT;
            }

            Depth = -8999;

            Add(new StaticMover {
                OnShake = OnShake,
                SolidChecker = IsRiding,
                OnDestroy = RemoveSelf
            });
            Add(new PlayerCollider(OnPlayer));

            this._turretSprites = new Sprite[turretCount];
            this._turretSolids = new Solid[turretCount];
            this.AddTurrets(position, width, turretCount, direction);


            foreach (var solid in this._turretSolids) {
                solid.Collidable = enableCollision;
            }

            _particleSpanPeriod = 256f / (width * height);

            if (!string.IsNullOrEmpty(activationConditionControlls)) {
                foreach (string activationControlString in activationConditionControlls.Split(',')) {
                    string[] activationControlParts = activationControlString.Split(':');

                    if (activationControlParts.Length != 3) {
                        continue;
                    }

                    if (!Enum.TryParse(activationControlParts[2].Trim().ToLower(), true, out ActivationCondition mode)) {
                        continue;
                    }

                    string stateString = activationControlParts[1].Trim().ToLower();
                    bool state;

                    if (stateString == "true" || stateString == "on") {
                        state = true;
                    } else if (stateString == "false" || stateString == "off") {
                        state = false;
                    } else {
                        continue;
                    }

                    string flag = activationControlParts[0].Trim();

                    _activationConditionControls[flag] = (state, mode);
                    _activationConditionControlsOrder.Add(flag);
                }
                _activationConditionControlsOrder.Reverse();
            }
        }


        public DashNegator(EntityData data, Vector2 offset)
            : this(data.Position + offset,
                   data.Width,
                   data.Height,
                   data.Attr("activationId"),
                   data.Bool("startActive"),
                   data.Enum<ActivationCondition>("activationCondition", ActivationCondition.OnDash),
                   data.Enum<Direction>("direction", Direction.Down),
                   data.Bool("enableCollision", true),
                   data.Attr("activationConditionControlls")) {
        }

        private void AddTurrets(Vector2 position, int width, int turretCount, Direction direction) {

            for (int i = 0; i < turretCount; i++) {
                Sprite turretSprite = new Sprite(GFX.Game, "danger/FactoryHelper/dashNegator/");
                Add(_turretSprites[i] = turretSprite);
                turretSprite.Add("inactive", "turret", 1f, 0);
                turretSprite.Add("rest", "turret", 0.2f, "active", 0);
                turretSprite.Add("active", "turret", 0.05f, "rest");
                turretSprite.CenterOrigin();
                if (direction == Direction.Down) {
                    turretSprite.Rotation = 0.0f;
                    turretSprite.Position = new Vector2((TEXTURE_WIDTH * i) + turretSprite.Width / 2, (turretSprite.Height / 2) - 2);
                    _turretSolids[i] = new Solid(position + new Vector2(TEXTURE_WIDTH * i, 0), TEXTURE_WIDTH, 4, false);
                } else if (direction == Direction.Right) {
                    turretSprite.Rotation = -1.57079637f;
                    turretSprite.Position = new Vector2(turretSprite.Width / 2 - 2, (TEXTURE_HIGHT * i) + (turretSprite.Height / 2) - 2);
                    _turretSolids[i] = new Solid(position + new Vector2(-4, TEXTURE_HIGHT * i), 4, TEXTURE_HIGHT, false);
                } else if (direction == Direction.Left) {
                    turretSprite.Rotation = 1.57079637f;
                    turretSprite.Position = new Vector2(width - turretSprite.Width / 2 + 2, (TEXTURE_HIGHT * i) + (turretSprite.Height / 2) - 2);
                    _turretSolids[i] = new Solid(position + new Vector2(width, 0) + new Vector2(0, TEXTURE_HIGHT * i), 4, TEXTURE_HIGHT, false);
                }
            }
        }

        private void OnSteamWall(SteamWall obj) {
            Activator.ForceDeactivate();
        }

        public override void Added(Scene scene) {
            base.Added(scene);
            foreach (Solid solid in _turretSolids) {
                scene.Add(solid);
            }

            Activator.HandleStartup(scene);
        }

        public override void Removed(Scene scene) {
            foreach (Solid solid in _turretSolids) {
                scene.Remove(solid);
            }

            base.Removed(scene);
        }

        public override void Update() {
            base.Update();

            if (Visible && Activator.IsOn && Scene.OnInterval(_particleSpanPeriod)) {
                SceneAs<Level>().ParticlesFG.Emit(P_NegatorField, 1, Position + Collider.Center, new Vector2(Width / 2, Height / 2));
            }

            foreach (string key in _activationConditionControlsOrder) {
                bool currentFlagState = (Scene as Level).Session.GetFlag(key);
                (bool, ActivationCondition) value = _activationConditionControls[key];

                bool expectedFlagState = value.Item1;
                if (currentFlagState == expectedFlagState) {
                    ActivationCondition newActivationCondition = value.Item2;
                    _activationCondition = newActivationCondition;
                }
            }
        }

        public override void Render() {
            Color color = Color.DarkRed * 0.3f;
            foreach (var item in _turretSprites) {
                Draw.Circle(this.Position + item.Position, 3, Color.Red, 3);
            }
            if (Visible && Activator.IsOn) {
                Draw.Rect(Collider, color);

                Player player = Scene.Tracker.GetEntity<Player>();
                if (player != null) {
                    if (this._direction == Direction.Down && !(player.Top - 4f > Bottom || player.Bottom < Top)) {
                        float left = Math.Min(Math.Max(Left, player.Left - 2f), Right);
                        float right = Math.Max(Math.Min(Right, player.Right + 2f), left);
                        Draw.Rect(left, Top, right - left, Height, Color.Red * 0.3f);
                    } else if ((this._direction == Direction.Left || this._direction == Direction.Right) && !(player.Right < Left || player.Left > Right)) {
                        float top = Math.Min(Math.Max(Top, player.Top), Bottom);
                        float bottom = Math.Max(Math.Min(Bottom, player.Bottom), Top);
                        Draw.Rect(Left, top, Width, bottom - top, Color.Red * 0.3f);
                    }
                }
            }

            base.Render();
        }

        private void OnTurnOn() {
            foreach (Sprite sprite in _turretSprites) {
                sprite.Play("active", true);
            }

            Fizzle();
        }

        private void OnTurnOff() {
            foreach (Sprite sprite in _turretSprites) {
                sprite.Play("inactive");
            }

            Fizzle();
        }

        private void OnStartOn() {
            foreach (Sprite sprite in _turretSprites) {
                sprite.Play("active", true);
            }
        }

        private void OnStartOff() {
            foreach (Sprite sprite in _turretSprites) {
                sprite.Play("inactive");
            }
        }

        private void Fizzle() {
            for (int i = 0; i < Width; i += TEXTURE_WIDTH) {
                for (int j = 0; j < Height; j += TEXTURE_WIDTH) {
                    SceneAs<Level>().ParticlesFG.Emit(P_NegatorField, 1, Position + new Vector2(4 + i, 4 + j), new Vector2(4, 4));
                }
            }
        }

        private void OnPlayer(Player player) {
            if (!Activator.IsOn) {
                return;
            }

            bool shouldActivate = false;

            switch (this._activationCondition) {
                case ActivationCondition.OnDash: {
                        shouldActivate = player.StartedDashing;
                        break;
                    }
                case ActivationCondition.IsDashing: {
                        shouldActivate = player.DashAttacking;
                        break;
                    }
                case ActivationCondition.IsNotDashing: {
                        shouldActivate = !player.DashAttacking;
                        break;
                    }
            }

            if (shouldActivate) {
                ShootClosestLaserToPlayer(player);
                player.Die(Vector2.UnitY);
            }
        }

        private void ShootClosestLaserToPlayer(Player player) {
            Audio.Play("event:/char/badeline/boss_laser_fire", player.Position);
            Vector2 beamPosition = new(Position.X, Position.Y);
            Vector2 targetVector = Vector2.Zero;

            if (this._direction == Direction.Down) {
                beamPosition.X += Math.Min((int)(player.Center.X - Left) / TEXTURE_WIDTH * TEXTURE_WIDTH, Width - 12) + TEXTURE_WIDTH / 2;
                beamPosition.Y += TEXTURE_HIGHT / 2;
                targetVector = Vector2.UnitY;
            } else if (this._direction == Direction.Right) {
                beamPosition.X += TEXTURE_HIGHT / 2;
                beamPosition.Y -= Math.Min(Width - 12, (int)(Top - player.Center.Y) / TEXTURE_WIDTH * TEXTURE_WIDTH) - TEXTURE_WIDTH / 2;
                targetVector = Vector2.UnitX;
            } else if (this._direction == Direction.Left) {
                beamPosition.X += Width - TEXTURE_HIGHT / 2;
                beamPosition.Y -= Math.Min(Width - 12, (int)(Top - player.Center.Y) / TEXTURE_WIDTH * TEXTURE_WIDTH) - TEXTURE_WIDTH / 2;
                targetVector = -Vector2.UnitX;
            }
            Scene.Add(new DashNegatorBeam(beamPosition, targetVector));
        }

        private void OnShake(Vector2 pos) {
            foreach (Component component in Components) {
                if (component is Image) {
                    (component as Image).Position = pos;
                }
            }
        }

        private bool IsRiding(Solid solid) {
            bool riding = false;
            foreach (Solid turret in _turretSolids) {
                if (turret.CollideCheck(solid, turret.Position - Vector2.UnitY)) {
                    riding = true;
                    break;
                }
            }

            return riding;
        }
    }
}