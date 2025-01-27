﻿using Celeste;
using Celeste.Mod.Entities;
using FactoryHelper.Components;
using Microsoft.Xna.Framework;
using Monocle;
using System;
using System.Collections;

namespace FactoryHelper.Entities {
    [CustomEntity("FactoryHelper/Conveyor")]
    [Tracked]
    public class Conveyor : Solid {
        public const float ConveyorMoveSpeed = 40.0f;

        private const string _spriteRoot = "objects/FactoryHelper/conveyor/";
        private const float _beltFrequency = 0.025f;
        private const float _gearFrequency = 0.05f;

        private static readonly ParticleType _grindParticleRight = new() {
            Size = 1f,
            Color = Calc.HexToColor("6b675d"),
            Color2 = Calc.HexToColor("db8d2e"),
            ColorMode = ParticleType.ColorModes.Blink,
            FadeMode = ParticleType.FadeModes.Late,
            SpeedMin = 15f,
            SpeedMax = 20f,
            Acceleration = Vector2.UnitY * 2f,
            DirectionRange = (float)Math.PI / 2f,
            Direction = 0,
            LifeMin = 1.0f,
            LifeMax = 2.0f
        };
        private static readonly ParticleType _grindParticleLeft = new() {
            Size = 1f,
            Color = Calc.HexToColor("6b675d"),
            Color2 = Calc.HexToColor("db8d2e"),
            ColorMode = ParticleType.ColorModes.Blink,
            FadeMode = ParticleType.FadeModes.Late,
            SpeedMin = 15f,
            SpeedMax = 20f,
            Acceleration = Vector2.UnitY * 2f,
            DirectionRange = (float)Math.PI / 2f,
            Direction = (float)Math.PI,
            LifeMin = 1.0f,
            LifeMax = 2.0f
        };

        private readonly Sprite[] _edgeSprites = new Sprite[2];
        private readonly Sprite[] _gearSprites = new Sprite[2];
        private readonly SoundSource _sfx;
        private Sprite[] _midSprites;

        public Conveyor(Vector2 position, float width, bool startLeft, string activationId) 
            : base(position, width, 16, false) {
            Add(Activator = new FactoryActivator());
            Activator.StartOn = startLeft;
            Activator.ActivationId = activationId;
            Activator.OnTurnOff = () => {
                Add(new Coroutine(Sparks()));
                ReverseConveyorDirection();
            };
            Activator.OnStartOff = () => {
                StartAnimation();
                ReverseConveyorDirection();
            };
            Activator.OnTurnOn = () => {
                Add(new Coroutine(Sparks()));
                ReverseConveyorDirection();
            };
            Activator.OnStartOn = StartAnimation;

            Add(new SteamCollider(OnSteamWall));

            SetupSprites();

            Add(new LightOcclude(0.2f));
            Add(_sfx = new SoundSource() { Position = new Vector2(Width / 2, Height / 2) });
        }

        public Conveyor(EntityData data, Vector2 offset)
            : this(data.Position + offset, data.Width, data.Bool("startLeft", true), data.Attr("activationId", "")) {
        }

        public FactoryActivator Activator { get; }
        public bool IsMovingLeft => Activator.IsOn;
        public bool IsBrokenDown { get; private set; } = false;

        private void OnSteamWall(SteamWall obj) {
            Add(new Coroutine(Sparks()));
            StopAnimation();
            IsBrokenDown = true;
        }

        private void SetupSprites() {
            for (int i = 0; i < 2; i++) {
                Add(_edgeSprites[i] = new Sprite(GFX.Game, _spriteRoot));
                _edgeSprites[i].Add("left", "belt_edge", _beltFrequency, "left");
                _edgeSprites[i].Position = new Vector2((Width - 16) * i, 0);

                Add(_gearSprites[i] = new Sprite(GFX.Game, _spriteRoot));
                _gearSprites[i].Add("left", "gear", _gearFrequency, "left");
                _gearSprites[i].Position = new Vector2((Width - 16) * i, 0);
            }

            _edgeSprites[1].Rotation = (float)Math.PI;
            _edgeSprites[1].Position += new Vector2(16, 16);

            _midSprites = new Sprite[((int)Width / 8) - 4];

            for (int i = 0; i < _midSprites.Length; i++) {
                Add(_midSprites[i] = new Sprite(GFX.Game, _spriteRoot));
                _midSprites[i].Add("left", "belt_mid", _beltFrequency, "left");
                _midSprites[i].Position = new Vector2(16 + (8 * i), 0);
            }
        }

        public override void Update() {
            base.Update();
            if (!_sfx.Playing) {
                _sfx.Play("event:/env/local/09_core/conveyor_idle");
            }
        }

        public override void Added(Scene scene) {
            base.Added(scene);
            Activator.HandleStartup(scene);
        }

        private IEnumerator Sparks() {
            for (int i = 0; i < 10; i++) {
                SceneAs<Level>().ParticlesFG.Emit(_grindParticleLeft, 1, Position + new Vector2(8, 8), new Vector2(4, 4));
                SceneAs<Level>().ParticlesFG.Emit(_grindParticleRight, 1, Position + new Vector2(Width - 8, 8), new Vector2(4, 4));
                yield return 0.05f;
            }
        }

        private void StartAnimation() {
            PlayAnimationInArray(_midSprites);
            PlayAnimationInArray(_edgeSprites);
            PlayAnimationInArray(_gearSprites);
            _edgeSprites[1].SetAnimationFrame(4);
        }

        private void StopAnimation() {
            StopAnimationInArray(_midSprites);
            StopAnimationInArray(_edgeSprites);
            StopAnimationInArray(_gearSprites);
        }

        private void ReverseConveyorDirection() {
            ReverseAnimationInArray(_midSprites);
            ReverseAnimationInArray(_edgeSprites);
            ReverseAnimationInArray(_gearSprites);
        }

        private void ReverseAnimationInArray(Sprite[] array) {
            foreach (Sprite sprite in array) {
                sprite.Rate = -sprite.Rate;
            }
        }

        private void PlayAnimationInArray(Sprite[] array) {
            foreach (Sprite sprite in array) {
                sprite.Play("left");
            }
        }

        private void StopAnimationInArray(Sprite[] array) {
            foreach (Sprite sprite in array) {
                sprite.Stop();
            }
        }
    }
}
