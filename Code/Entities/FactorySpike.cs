using Celeste;
using Microsoft.Xna.Framework;
using Monocle;

namespace FactoryHelper.Entities {
    public class FactorySpike : Entity {
        public Directions Direction;

        protected PlayerCollider pc;
        protected Vector2 imageOffset;
        protected int size;

        public FactorySpike(Vector2 position, int size, Directions direction)
            : base(position) {
            Depth = -1;
            Direction = direction;
            this.size = size;
            Add(new StaticMover {
                OnShake = OnShake,
                SolidChecker = IsRiding,
                JumpThruChecker = IsRiding,
                OnEnable = OnEnable,
                OnDisable = OnDisable
            });
        }

        public FactorySpike(EntityData data, Vector2 offset, Directions dir)
            : this(data.Position + offset, GetSize(data, dir), dir) {
        }

        public enum Directions {
            Up,
            Down,
            Left,
            Right
        }

        private void OnEnable() {
            Active = Visible = Collidable = true;
        }

        private void OnDisable() {
            Active = Visible = Collidable = false;
        }

        private void OnShake(Vector2 amount) {
            imageOffset += amount;
        }

        public override void Render() {
            Vector2 position = Position;
            Position += imageOffset;
            base.Render();
            Position = position;
        }

        public void SetOrigins(Vector2 origin) {
            foreach (Component component in Components) {
                if (component is Image image) {
                    Vector2 vector = origin - Position;
                    image.Origin = image.Origin + vector - image.Position;
                    image.Position = vector;
                }
            }
        }

        protected virtual void OnCollide(Player player) {
            switch (Direction) {
                case Directions.Up:
                    if (player.Speed.Y >= 0f && player.Bottom <= Bottom) {
                        player.Die(new Vector2(0f, -1f));
                    }

                    break;
                case Directions.Down:
                    if (player.Speed.Y <= 0f) {
                        player.Die(new Vector2(0f, 1f));
                    }

                    break;
                case Directions.Left:
                    if (player.Speed.X >= 0f) {
                        player.Die(new Vector2(-1f, 0f));
                    }

                    break;
                case Directions.Right:
                    if (player.Speed.X <= 0f) {
                        player.Die(new Vector2(1f, 0f));
                    }

                    break;
            }
        }

        protected static int GetSize(EntityData data, Directions dir) {
            return dir switch {
                Directions.Up or Directions.Down => data.Width,
                _ => data.Height,
            };
        }

        protected virtual bool IsRiding(Solid solid) {
            return Direction switch {
                Directions.Up => CollideCheckOutside(solid, Position + Vector2.UnitY),
                Directions.Down => CollideCheckOutside(solid, Position - Vector2.UnitY),
                Directions.Left => CollideCheckOutside(solid, Position + Vector2.UnitX),
                Directions.Right => CollideCheckOutside(solid, Position - Vector2.UnitX),
                _ => false,
            };
        }

        protected virtual bool IsRiding(JumpThru jumpThru) {
            return Direction == Directions.Up && CollideCheck(jumpThru, Position + Vector2.UnitY);
        }
    }
}
