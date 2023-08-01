package com.example.crosstheroad;
import android.graphics.Bitmap;

/**
 * These are all the types of Tiles available.
 */

/**
 * The Tile class extends Entity and centralizes all Tile objects.
 * Purpose: provide singularity amongst all Entity type objects & reduce lazy class.
 * (String) type - specifies what type of tile is being instantiated
 * (int) value - this is the damage/increase value of a particular tile.
 * note: the value is not based on Tile type but rather is unique to each tile object.
 * (boolean) done - this type is reserved for End tile types
 */
public class Tile extends Entity {
    private final Enum type;
    private int value;
    private boolean done;
    public Tile(int x, int y, int w, int h, Bitmap bm, Enum type, int value) {
        super(x, y, w, h, bm);
        this.type = type;
        this.value = value;
    }
    /**
     * This method assigns an enum type to the given String type.
     * This ensures there's no ambiguity with whatever the programmer types in.
     */
    void assignType() { }

    /**
     * Getter method for the Done boolean.
     * This should only be used for the End type tile.
     * COMMENT: Should we get rid of this? Might be difficult to ensure no other type uses it.
     * @return done if type is End, else returns null.
     */
    public Boolean getDone() {
        if (this.type == Type.END) {
            return done;
        }
        return null;
    }

    /**
     * Setter method for the Done boolean.
     * Ensures that this can only be set for the End tile.
     * @param done - boolean done for End tile.
     *             If End tile is reached, done is true, else false.
     */
    public void setDone(Boolean done) {
        if (this.type == Type.END) {
            this.done = done;
        }
    }

    /**
     * Setter method for the Tile value.
     * @param value - int representing the consequences of colliding with this Tile.
     */
    public void setValue(int value) {
        this.value = value;
    }

    /**
     * This is the getter method for the Tile value.
     * @return value - the given value associated with the tile.
     */
    public int getValue() {
        return value;
    }
}
