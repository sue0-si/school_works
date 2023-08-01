package com.example.crosstheroad;

import static com.example.crosstheroad.Type.RIVER;
import static com.example.crosstheroad.Type.ROAD;
import static com.example.crosstheroad.Type.SAFE;


import androidx.appcompat.app.AppCompatActivity;

import android.annotation.SuppressLint;
import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.os.Bundle;
import android.os.Handler;
import android.util.AttributeSet;
import android.view.View;
import android.widget.TextView;

/**
 * Game class contains GameView class.
 * Game class attributes:
 *      diff - String
 *      lives - int
 *      username - String
 *      avatar - Bitmap
 *      game - GameView
 * GameView class attributes:
 *      lives - int
 *      score - Score
 *      player - player
 *      liveView TextView
 *   multiple more tiles
 *
 */
public class Game extends AppCompatActivity {

    public void setDiff(String diff) {
        this.diff = diff;
    }

    private String diff;

    public void setLives(int lives) {
        this.lives = lives;
    }

    private int lives;

    private String username;

    public void setUsername(String username) {
        this.username = username;
    }

    private Bitmap avatar;

    private GameView game;
    public void setEasy() {
        setDiff("Easy");
        setLives(5);
        game.lives = 5;
    }
    public void setMedium() {
        setDiff("Medium");
        setLives(3);
        game.lives = 3;
    }
    public void setHard() {
        setDiff("Hard");
        setLives(1);
        game.lives = 1;
    }

    @SuppressLint("ClickableViewAccessibility")
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_game);

        Intent intent = getIntent();
        String username = intent.getStringExtra("EXTRA_USERNAME");
        diff = intent.getStringExtra("EXTRA_DIFF");
        String playerSprite = intent.getStringExtra("EXTRA_SPRITE");

        TextView userText = (TextView) findViewById(R.id.textView2);
        userText.setText(username);

        game = findViewById(R.id.game);
        game.points = (TextView) findViewById(R.id.textView9);

        chooseAvatar(playerSprite);
        setDifficulty(diff);

        //Delete the two height lines
        int gameWidth = game.getLayoutParams().width;
        game.player = new Player((gameWidth / 2) - 100, 1600, 200, 200, avatar);

        TextView lives = (TextView) findViewById(R.id.textView5);
        lives.setText(String.valueOf(game.lives));
        game.liveView = lives;

        game.setOnTouchListener(new OnSwipeTouchListener(this) {
            public void onSwipeDown() {
                game.swipeDown();
            }

            public void onSwipeUp() {
                game.swipeUp();
            }

            public void onSwipeLeft() {
                game.swipeLeft();
            }

            public void onSwipeRight() {
                game.swipeRight();
            }

        });
    }
    private void chooseAvatar(String playerSprite) {
        if (playerSprite.equals("Kitty")) {
            avatar = BitmapFactory.decodeResource(getResources(), R.drawable.cat);
        } else if (playerSprite.equals("Turtle")) {
            avatar = BitmapFactory.decodeResource(getResources(), R.drawable.turtle);
        } else {
            avatar = BitmapFactory.decodeResource(getResources(), R.drawable.frog);
        }
        this.avatar = Bitmap.createScaledBitmap(avatar, 200, 200, true);
    }

    protected void setDifficulty(String difficulty) {
        if (difficulty.equals("Easy")) {
            setEasy();
        } else if (difficulty.equals("Medium")) {
            setMedium();
        } else {
            setHard();
        }
        TextView diffText = (TextView) findViewById(R.id.textView10);
        diffText.setText(difficulty);
    }

    public static class GameView extends View {

        public int getLives() {
            return lives;
        }

        public void setLives(int lives) {
            this.lives = lives;
        }

        private int lives;

        public void setScore(Score score) {
            this.score = score;
        }

        public Score getScore() {
            return score;
        }

        private Score score;
        private Player player;

        public void setPoints(TextView points) {
            this.points = points;
        }

        private TextView points;

        public void setLiveView(TextView liveView) {
            this.liveView = liveView;
        }

        private TextView liveView;

        public void setPlayer(Player player) {
            this.player = player;
        }

        private End end = new End(0, 0, 1600, 200, Bitmap.createScaledBitmap(
                BitmapFactory.decodeResource(getResources(), R.drawable.end),
                1400, 200, true));

        /*
        Please note that the variable start is of Safe type.
        I did not bother changing its name to start_safe for the sake of simplicity.
         */
        private Tile start = new Tile(0, 1600, 1400, 200, Bitmap.createScaledBitmap(
                BitmapFactory.decodeResource(getResources(), R.drawable.safe),
                1400, 200, true), SAFE, 100);

        public End getEnd() {
            return end;
        }

        public void setEnd(End end) {
            this.end = end;
        }

        public Tile getStart() {
            return start;
        }

        public void setStart(Tile start) {
            this.start = start;
        }

        public Tile getRoad1() {
            return road1;
        }

        public void setRoad1(Tile road1) {
            this.road1 = road1;
        }

        public Tile getSafe1() {
            return safe1;
        }

        public void setSafe1(Tile safe1) {
            this.safe1 = safe1;
        }

        public Tile[] getRoads() {
            return roads;
        }

        public void setRoads(Tile[] roads) {
            this.roads = roads;
        }

        private Tile[] roads;

        private Tile road1 = new Tile(0, 800, 1400, 200, Bitmap.createScaledBitmap(
                BitmapFactory.decodeResource(getResources(), R.drawable.road),
                1400, 200, true), ROAD, 75);

        private Tile road2 = new Tile(0, 1000, 1400, 200, Bitmap.createScaledBitmap(
                BitmapFactory.decodeResource(getResources(), R.drawable.road),
                1400, 200, true), ROAD, 100);


        private final Tile road3 = new Tile(0, 1200, 1400, 200, Bitmap.createScaledBitmap(
                BitmapFactory.decodeResource(getResources(), R.drawable.road),
                1400, 200, true), ROAD, 80);


        //        private Road road4 = new Road(0, 1400, 1400, 200, Bitmap.createScaledBitmap(
        //                BitmapFactory.decodeResource(getResources(), R.drawable.road),
        //                1400, 200, true));

        private final Tile road4 = new Tile(0, 1400, 1400, 200, Bitmap.createScaledBitmap(
                BitmapFactory.decodeResource(getResources(), R.drawable.road),
                1400, 200, true), ROAD, 65);

        }
        public void setRiver1(Tile river1) {
            this.river1 = river1;
        }

        private Tile river1 = new Tile(0, 200, 1400, 400, Bitmap.createScaledBitmap(
                BitmapFactory.decodeResource(getResources(), R.drawable.river),
                1400, 400, true), RIVER, 100);

        private Tile safe1 = new Tile(0, 600, 1400, 200, Bitmap.createScaledBitmap(
                BitmapFactory.decodeResource(getResources(), R.drawable.safe),
                1400, 200, true), SAFE, 50);

        private Handler handler;
        private Context context;

        public Moveable[] getCars() {
            return cars;
        }

        public void setCars(Moveable[] cars) {
            this.cars = cars;
        }

        private Moveable[] cars;

        public void setLogs(Moveable[] logs) {
            this.logs = logs;
        }

        private Moveable[] logs;

        private int height;
        private String overString;

        public GameView(Context context, AttributeSet attrs) {
            super(context, attrs);
            this.context = context;
            this.handler = new Handler();
            Moveable car1 = new Moveable(0, 1200, 200, 200, Bitmap.createScaledBitmap(
                    BitmapFactory.decodeResource(getResources(), R.drawable.red),
                    200, 200, true), 10);
            Moveable car2 = new Moveable(1100, 1400, 300, 200, Bitmap.createScaledBitmap(
                    BitmapFactory.decodeResource(getResources(), R.drawable.blue),
                    300, 200, true), -5);
            Moveable car3 = new Moveable(300, 1400, 300, 200, Bitmap.createScaledBitmap(
                    BitmapFactory.decodeResource(getResources(), R.drawable.blue),
                    300, 200, true), -5);
            Moveable car4 = new Moveable(300, 1000, 500, 200, Bitmap.createScaledBitmap(
                    BitmapFactory.decodeResource(getResources(), R.drawable.purple),
                    500, 200, true), -2);
            Moveable car5 = new Moveable(300, 800, 100, 200, Bitmap.createScaledBitmap(
                    BitmapFactory.decodeResource(getResources(), R.drawable.orangepng),
                    100, 200, true), 14);
            Moveable car6 = new Moveable(1100, 1000, 500, 200, Bitmap.createScaledBitmap(
                    BitmapFactory.decodeResource(getResources(), R.drawable.purple),
                    500, 200, true), -2);

            Moveable log1 = new Moveable(0, 200, 300, 200, Bitmap.createScaledBitmap(
                    BitmapFactory.decodeResource(getResources(), R.drawable.brown1),
                    300, 200, true), 4);
            Moveable log2 = new Moveable(500, 200, 300, 200, Bitmap.createScaledBitmap(
                    BitmapFactory.decodeResource(getResources(), R.drawable.brown2),
                    300, 200, true), 4);
            Moveable log3 = new Moveable(900, 200, 300, 200, Bitmap.createScaledBitmap(
                    BitmapFactory.decodeResource(getResources(), R.drawable.brown1),
                    300, 200, true), 4);
            Moveable log4 = new Moveable(0, 400, 500, 200, Bitmap.createScaledBitmap(
                    BitmapFactory.decodeResource(getResources(), R.drawable.brown1),
                    500, 200, true), -2);
            Moveable log5 = new Moveable(800, 400, 500, 200, Bitmap.createScaledBitmap(
                    BitmapFactory.decodeResource(getResources(), R.drawable.brown2),
                    500, 200, true), -2);

            roads = new Tile[4];
            roads[0] = road1;
            roads[1] = road2;
            roads[2] = road3;
            roads[3] = road4;

            cars = new Moveable[6];
            cars[0] = car1;
            cars[1] = car2;
            cars[2] = car3;
            cars[3] = car4;
            cars[4] = car5;
            cars[5] = car6;

            logs = new Moveable[5];
            logs[0] = log1;
            logs[1] = log2;
            logs[2] = log3;
            logs[3] = log4;
            logs[4] = log5;

            score = new Score();
        }
        public void onDraw(Canvas canvas) {
            super.onDraw(canvas);

            canvas.drawRGB(80, 180, 20);
            canvas.drawBitmap(start.getBm(), start.getLeft(), start.getTop(), null);
            canvas.drawBitmap(end.getBm(), end.getLeft(), end.getTop(), null);
            for (Tile road: roads) {
                canvas.drawBitmap(road.getBm(), road.getLeft(), road.getTop(), null);
            }
            canvas.drawBitmap(safe1.getBm(), safe1.getLeft(), safe1.getTop(), null);
            canvas.drawBitmap(river1.getBm(), river1.getLeft(), river1.getTop(), null);

            for (Moveable car: cars) {
                car.move();
                canvas.drawBitmap(car.getBm(), car.getLeft(), car.getTop(), null);
            }
            for (Moveable log: logs) {
                log.move();
                canvas.drawBitmap(log.getBm(), log.getLeft(), log.getTop(), null);
            }
            canvas.drawBitmap(player.getBm(), player.getLeft(), player.getTop(), null);
            collisions();
            invalidate();
        }

        protected void collisions() {
            if ((Hits.collides(player, end)) && !(end.getDone())) {
                end.setDone(true);
                changeScore(true);
                gameOver("Victory!");
            } else if (Hits.collides(player, logs)) {
                Moveable logHit = (Moveable) Hits.which(player, logs);
                if (logHit != null) {
                    player.setRight(player.getRight() + logHit.getVel());
                }
                if (logHit != null) {
                    player.setLeft(player.getLeft() + logHit.getVel());
                }
                if ((player.getLeft() < 0) || (player.getRight() > 1400)) {
                    decreaseLife();
                }
            } else if ((Hits.collides(player, river1)) || (Hits.collides(player, cars))) {
                decreaseLife();
            }
        }
        public void decreaseLife() {
            player.resetPos();
            if (lives > 1) {
                lives -= 1;
                liveView.setText(String.valueOf(lives));
                score.setDisplayScore(0);
                score.setDynamicScore(0);
                points.setText(String.valueOf(score.updateScore()));
            } else {
                overString = "gameOver";
                gameOver("Game Over");
            }
        }

        protected void gameOver(String str) {
            Intent intent = new Intent(getContext(), GameOver.class);
            String finalScore = String.valueOf(score.getHighScore());

            intent.putExtra("EXTRA_SCORE", finalScore);
            intent.putExtra("EXTRA_STATE", str);
            context.startActivity(intent);
        }

        public String getOver() {
            return overString;
        }

        public void swipeDown() {
            if (player.getTop() < 1600) {
                player.setBottom(player.getBottom() + 200);
                player.setTop(player.getTop() + 200);
                changeScore(false);
            }
        }

        public void swipeUp() {
            if (player.getTop() > 0) {
                changeScore(true);
                player.setBottom(player.getBottom() - 200);
                player.setTop(player.getTop() - 200);
            }
        }

        public void swipeRight() {
            if (player.getRight() < 1400) {
                player.setRight(player.getRight() + 200);
                player.setLeft(player.getLeft() + 200);
            }
        }
        public void changeScore(boolean incr) {
            int dir;
            if (incr) {
                dir = 1;
            } else {
                dir = -1;
            }
            int change = 5;

            Tile[] tile = new Tile[] {river1, road1, road2, road3, road4, safe1, start, end};

            if (Hits.collides(player, tile)) {
                Tile hitTile = (Tile) Hits.which(player, tile);
                assert hitTile != null;
                change = hitTile.getValue();
            }
            score.setDynamicScore(score.getDynamicScore() + (change * dir));
            int newScore = score.updateScore();
            if (points != null) {
                points.setText(String.valueOf(newScore));
            }
        }

        public void swipeLeft() {
            if (player.getLeft() > 0) {
                player.setLeft(player.getLeft() - 200);
                player.setRight(player.getRight() - 200);
            }
        }
    }
