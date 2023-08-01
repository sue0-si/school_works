package com.example.crosstheroad;

/**
 * This class takes care of the player score.
 * Attributes:
 *  (int) dispalyScore: this score is to be displayed to the player
 *  (int) dynamicScore: this score takes care of the calculations in the background
 *  (int) highScore: keeps track of the players high score
 *
 *  Methods:
 *     setter/getter methods for the attributes
 *     int updateScore(void): updates player's highScore and displayScore
 */
public class Score {
    private int displayScore;

    public void setDisplayScore(int displayScore) {
        this.displayScore = displayScore;
    }

    public int getDynamicScore() {
        return dynamicScore;
    }

    public void setDynamicScore(int dynamicScore) {
        this.dynamicScore = dynamicScore;
    }

    private int dynamicScore;
    private int highScore;

    public Score() {
        displayScore = 0;
        dynamicScore = 0;
        highScore = 0;

    }

    public int getHighScore() {
        return highScore;
    }

    public int updateScore() {
        if (dynamicScore > displayScore) {
            displayScore = dynamicScore;
        }
        if (dynamicScore > highScore) {
            highScore = dynamicScore;
        }
        return displayScore;
    }
}
