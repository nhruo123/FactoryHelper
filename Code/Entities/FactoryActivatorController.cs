using Celeste;
using Celeste.Mod.Entities;
using FactoryHelper.Components;
using Microsoft.Xna.Framework;
using Monocle;
using System;

namespace FactoryHelper.Entities;


[CustomEntity("FactoryHelper/FactoryActivatorController")]
class FactoryActivatorController : Entity {
    private string _activationId = null;
    private string _activationFlag = null;
    private FactoryActivator _activator = null;

    public FactoryActivatorController(EntityData data, Vector2 offset)
        : base(data.Position + offset) {
        _activationId = data.Attr("activationId");
        _activationFlag = data.Attr("activationFlag");

        if (string.IsNullOrEmpty(_activationId) || string.IsNullOrEmpty(_activationFlag)) {
            Console.WriteLine("Removing Self!");
            Active = false;
            RemoveSelf();
        }
    }

    public override void Awake(Scene scene) {
        base.Awake(scene);
        foreach (FactoryActivator activator in scene.Tracker.GetComponents<FactoryActivator>()) {
            if (activator.ActivationId == _activationId) {
                _activator = activator;
            }
        }
    }
    public override void Update() {
        base.Update();
        if (_activator == null) {
            return;
        }
        bool currentFlag = (Scene as Level).Session.GetFlag(_activationFlag);

        if (currentFlag != _activator.IsOn) {
            if (currentFlag) {
                _activator.Activate(false);
            } else {
                _activator.Deactivate(false);
            }
        }
    }
}