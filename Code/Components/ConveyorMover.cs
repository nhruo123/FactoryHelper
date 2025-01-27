﻿using FactoryHelper.Entities;
using Microsoft.Xna.Framework;
using Monocle;
using System;

namespace FactoryHelper.Components {
    [Tracked]
    public class ConveyorMover : Component {
        public Action<float> OnMove;
        public bool IsOnConveyor = false;

        public ConveyorMover() 
            : base(true, true) {
        }

        public void Move(float amount) {
            OnMove?.Invoke(amount);
        }

        public override void Update() {
            base.Update();
            bool foundConveyor = false;
            foreach (Conveyor conveyor in Scene.Tracker.GetEntities<Conveyor>()) {
                if (!conveyor.IsBrokenDown && Collide.Check(conveyor, Entity, conveyor.Position - Vector2.UnitY)) {
                    foundConveyor = true;
                    Move(conveyor.IsMovingLeft ? -Conveyor.ConveyorMoveSpeed : Conveyor.ConveyorMoveSpeed);
                }
            }

            IsOnConveyor = foundConveyor;
        }
    }
}
