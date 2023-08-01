package com.example.crosstheroad;

/**
 * Hits made into a class to create streamlined cleanthiness in code.
 * Main methods:
 *      collides(Entity a, Entity b) : boolean
 *          if objects collide, return true.
 *      collides(Entity a, Entity[] arr) : boolean
 *          inputs an array of entities
 *      which(Entity a, Entity[] arr) : Entity
 *          figures which entity was collided with in array.
 */
public class Hits {
    public static boolean collides(Entity a, Entity b) {
        int center = (a.getLeft() + a.getRight()) / 2;
        return ((b.getTop() <= a.getTop()) && (b.getBottom() >= a.getBottom())
                && (center >= b.getLeft()) && (center <= b.getRight()));
    }
    public static boolean collides(Entity a, Entity[] arr) {
        for (Entity b: arr) {
            int center = (a.getLeft() + a.getRight()) / 2;
            if ((b.getTop() <= a.getTop()) && (b.getBottom() >= a.getBottom())
                    && (center >= b.getLeft()) && (center <= b.getRight())) {
                return true;
            }
        }
        return false;
    }
    public static Entity which(Entity a, Entity[] arr) {
        for (Entity b: arr) {
            int center = (a.getLeft() + a.getRight()) / 2;
            if ((b.getTop() <= a.getTop()) && (b.getBottom() >= a.getBottom())
                    && (center >= b.getLeft()) && (center <= b.getRight())) {
                return b;
            }
        }
        return null;
    }
}
