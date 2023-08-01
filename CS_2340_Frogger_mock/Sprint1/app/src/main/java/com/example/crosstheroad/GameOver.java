package com.example.crosstheroad;

import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.TextView;

/**
 * GameOver class - defines behavior for end of game.
 * Attributes:
 *      scoreText - TextView
 *      stateText - TextView
 * Method:
 *      onCreate(Bundle savedInstanceState) : void
 *          sets up state and score text
 *      restart(View view): void
 *          calls startActivity with new information
 *      close(View view) : void
 *
 */
public class GameOver extends AppCompatActivity {

    private TextView scoreText;

    private TextView stateText;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_game_over);
        Intent intent = getIntent();
        String score = intent.getStringExtra("EXTRA_SCORE");
        String state = intent.getStringExtra("EXTRA_STATE");
        stateText = (TextView) findViewById(R.id.textView4);
        stateText.setText(state);

        scoreText = (TextView) findViewById(R.id.textView5);
        scoreText.setText(score);
    }
    public void restart(View view) {
        startActivity(new Intent(GameOver.this, Config.class));
    }
    public void close(View view) {
        this.finishAffinity();
    }
}