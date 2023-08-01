package com.example.crosstheroad;

import static com.example.crosstheroad.Type.RIVER;
import static com.example.crosstheroad.Type.ROAD;
import static com.example.crosstheroad.Type.END;
import static com.example.crosstheroad.Type.SAFE;

import static org.junit.Assert.*;
import static org.mockito.Mockito.verify;

import android.widget.TextView;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.Mockito;
import org.mockito.junit.MockitoJUnitRunner;
import org.w3c.dom.Text;


@RunWith(MockitoJUnitRunner.class)
public class Sprint5Tests {
    @Test
    public void testRightwardLogCarry() {
        Game.GameView gameTest = Mockito.mock(Game.GameView.class, Mockito.CALLS_REAL_METHODS);

        Player player = new Player(0, 0, 10, 10, null);
        Score score = new Score();
        Tile river = new Tile(100, 100, 1400, 600, null, RIVER, 0);
        End end = new End(0, 0, 1, 1, null);

        Tile[] roads = new Tile[0];
        Moveable[] cars = new Moveable[0];
        Moveable[] logs = new Moveable[1];
        logs[0] = new Moveable(0, 0, 10, 10, null, 10);

        Mockito.doCallRealMethod().when(gameTest).setPlayer(player);
        Mockito.doCallRealMethod().when(gameTest).setScore(score);
        //Mockito.doCallRealMethod().when(gameTest).getScore();
        Mockito.doCallRealMethod().when(gameTest).setRiver1(river);
        Mockito.doCallRealMethod().when(gameTest).setEnd(end);
        Mockito.doCallRealMethod().when(gameTest).setLogs(logs);
        Mockito.doCallRealMethod().when(gameTest).setRoads(roads);
        Mockito.doCallRealMethod().when(gameTest).setCars(cars);
        Mockito.doCallRealMethod().when(gameTest).collisions();

        gameTest.setRoads(roads);
        gameTest.setEnd(end);
        gameTest.setLogs(logs);
        gameTest.setCars(cars);
        gameTest.setRiver1(river);
        gameTest.setScore(score);
        gameTest.setPlayer(player);

        assertEquals(0, player.getLeft());

        gameTest.collisions();

        assertEquals(10, player.getLeft());
    }

    @Test
    public void testRightwardLogReset() {
        Game.GameView gameTest = Mockito.mock(Game.GameView.class, Mockito.CALLS_REAL_METHODS);

        Player player = new Player(0, 0, 10, 10, null);
        Score score = new Score();
        Tile river = new Tile(100, 100, 1400, 600, null, RIVER, 0);
        End end = new End(0, 0, 1, 1, null);
        Tile[] roads = new Tile[0];
        Moveable[] cars = new Moveable[0];
        Moveable[] logs = new Moveable[1];
        logs[0] = new Moveable(0, 200, 10, 10, null, 2000);
        TextView view = new TextView(null);

        Mockito.doCallRealMethod().when(gameTest).setPlayer(player);
        Mockito.doCallRealMethod().when(gameTest).setLiveView(view);
        Mockito.doCallRealMethod().when(gameTest).setPoints(view);
        Mockito.doCallRealMethod().when(gameTest).setScore(score);
        //Mockito.doCallRealMethod().when(gameTest).getScore();
        Mockito.doCallRealMethod().when(gameTest).setRiver1(river);
        Mockito.doCallRealMethod().when(gameTest).setEnd(end);
        Mockito.doCallRealMethod().when(gameTest).setLogs(logs);
        Mockito.doCallRealMethod().when(gameTest).setLives(5);
        Mockito.doCallRealMethod().when(gameTest).setRoads(roads);
        Mockito.doCallRealMethod().when(gameTest).setCars(cars);
        Mockito.doCallRealMethod().when(gameTest).collisions();
        Mockito.doNothing().when(gameTest).changeScore(false);

        gameTest.setRoads(roads);
        gameTest.setEnd(end);
        gameTest.setLogs(logs);
        gameTest.setLiveView(view);
        gameTest.setPoints(view);
        gameTest.setCars(cars);
        gameTest.setRiver1(river);
        gameTest.setScore(score);
        gameTest.setPlayer(player);
        gameTest.setLives(5);


        assertEquals(0, player.getTop());
        gameTest.swipeDown();
        assertEquals(200, player.getTop());
        gameTest.collisions();

        assertEquals(0, player.getTop());
    }


    /**
     * The following two test cases test if the log loops around the left/right sides.
     * Test cases by Mariam
     */

    /**
     * Tests if log loops around the left side of the screen.
     */
    @Test
    public void testLogLoopLeft() {
        Moveable log = new Moveable(400, 600, 200, 200, null, 2);
        log.move();
        assertEquals(402, log.getLeft());
        assertEquals(602, log.getRight());
    }

    /**
     * Tests if log loops around the right side of the screen.
     */
    @Test
    public void testLogLoopRight() {
        Moveable log = new Moveable(400, 600, 200, 200, null, -3);
        log.move();
        assertEquals(597, log.getRight());
        assertEquals(397, log.getLeft());
    }


    // Leftward Log Carrying
    @Test
    public void testLeftwardLogCarry() {
        Game.GameView gameTest = Mockito.mock(Game.GameView.class, Mockito.CALLS_REAL_METHODS);

        Player player = new Player(0, 0, 10, 10, null);
        Score score = new Score();
        Tile river = new Tile(100, 100, 1400, 600, null, RIVER, 0);
        End end = new End(0, 0, 1, 1, null);

        Tile[] roads = new Tile[0];
        Moveable[] cars = new Moveable[0];
        Moveable[] logs = new Moveable[1];
        logs[0] = new Moveable(0, 0, 10, 10, null, 10);

        gameTest.setRoads(roads);
        gameTest.setEnd(end);
        gameTest.setLogs(logs);
        gameTest.setCars(cars);
        gameTest.setRiver1(river);
        gameTest.setScore(score);
        gameTest.setPlayer(player);

        assertEquals(10, player.getRight());

        gameTest.collisions();

        assertEquals(20, player.getRight());
    }

    // Player reset when carried off screen to left for log
    @Test
    public void testLeftwardLogReset() {
        Game.GameView gameTest = Mockito.mock(Game.GameView.class, Mockito.CALLS_REAL_METHODS);

        Player player = new Player(0, 0, 10, 10, null);
        Score score = new Score();
        Tile river = new Tile(100, 100, 1400, 600, null, ROAD, 0);
        End end = new End(0, 0, 1, 1, null);
        Tile[] roads = new Tile[0];
        Moveable[] cars = new Moveable[0];
        Moveable[] logs = new Moveable[1];
        logs[0] = new Moveable(0, 200, 10, 10, null, -20);
        TextView view = new TextView(null);

        Mockito.doNothing().when(gameTest).changeScore(false);

        gameTest.setRoads(roads);
        gameTest.setEnd(end);
        gameTest.setLogs(logs);
        gameTest.setLiveView(view);
        gameTest.setPoints(view);
        gameTest.setCars(cars);
        gameTest.setRiver1(river);
        gameTest.setScore(score);
        gameTest.setPlayer(player);
        gameTest.setLives(5);

        assertEquals(0, player.getTop());
        gameTest.swipeDown();
        assertEquals(200, player.getTop());
        gameTest.collisions();

        assertEquals(0, player.getTop());
    }

    @Test
    // Tests if jumping on log does not decrease lives
    public void testLogLoseLife() {
        Game.GameView gameTest = Mockito.mock(Game.GameView.class, Mockito.CALLS_REAL_METHODS);

        Player player = new Player(0, 0, 10, 10, null);
        Score score = new Score();
        Tile river = new Tile(100, 100, 1400, 600, null, RIVER, 0);
        End end = new End(0, 0, 1, 1, null);
        Tile[] roads = new Tile[0];
        Moveable[] cars = new Moveable[0];
        Moveable[] logs = new Moveable[1];
        logs[0] = new Moveable(0, 200, 10, 10, null, -20);
        TextView view = new TextView(null);

        gameTest.setRoads(roads);
        gameTest.setEnd(end);
        gameTest.setLogs(logs);
        gameTest.setLiveView(view);
        gameTest.setPoints(view);
        gameTest.setCars(cars);
        gameTest.setRiver1(river);
        gameTest.setScore(score);
        gameTest.setPlayer(player);
        gameTest.setLives(5);

        gameTest.swipeUp();
        gameTest.collisions();
        assertEquals(5, gameTest.getLives());
    }

    @Test
    //Checks whether the game ends when the player reaches end tile
    public void testEndTileGameOver() {
        Game.GameView gameTest = Mockito.mock(Game.GameView.class, Mockito.CALLS_REAL_METHODS);

        Player player = new Player(0, 0, 10, 10, null);
        End end = new End(0, 0, 10, 10, null);

        Mockito.doNothing().when(gameTest).changeScore(true);
        Mockito.doNothing().when(gameTest).gameOver("Victory!");

        gameTest.setPlayer(player);
        gameTest.setEnd(end);

        assertEquals(false, end.getDone());
        gameTest.collisions();
        assertEquals(true, end.getDone());
    }

    @Test
    public void testHitsWhichFindsCollidingEntity() {
        Entity a = new Entity(10,10,5,5,null);
        Entity[] arr = new Entity[3];
        Entity b = new Entity(30,30,5,5,null);
        Entity c = new Entity(40,40,5,5,null);
        Entity d = new Entity(10,10,5,5,null);
        arr[0] = b;
        arr[1] = c;
        arr[2] = d;

        assertEquals(d, Hits.which(a, arr));
    }

    @Test

    public void endTileWorthThreeHundred() {
        Game.GameView gameTest = Mockito.mock(Game.GameView.class, Mockito.CALLS_REAL_METHODS);
        Player player = new Player(0, 0, 10, 10, null);
        End end = new End(0, 0, 10, 10, null);

//        Mockito.doNothing().when(gameTest).changeScore(true);
//        Mockito.doNothing().when(gameTest).gameOver("Victory!");

        gameTest.setPlayer(player);
        gameTest.setEnd(end);
        assertEquals(300,end.getValue());
    }



    @Test

    //Checks that hit.collide works with array of entities
    public void checkHit() {
        Entity a = new Entity(10,10,5,5,null);
        Entity[] arr = new Entity[3];
        Entity b = new Entity(30,30,5,5,null);
        Entity c = new Entity(40,40,5,5,null);
        Entity d = new Entity(10,10,5,5,null);
        arr[0] = b;
        arr[1] = c;
        arr[2] = d;

        assertEquals(true, Hits.collides(a, arr));
    }

    @Test

    //Checks that hit.collide works with array of 0 entities

    public void checkHit2() {
        Entity a = new Entity(10,10,5,5,null);
        Entity[] arr = new Entity[0];

        assertEquals(false, Hits.collides(a, arr));
    }
}
