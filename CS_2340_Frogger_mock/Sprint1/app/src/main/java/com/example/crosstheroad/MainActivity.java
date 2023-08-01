package com.example.crosstheroad;
import androidx.appcompat.app.AppCompatActivity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.view.WindowManager;

/**
 * Sets up the game. Main Class.
 * Main Goal: call onCreate()
 * and configGame() to set up screen.
 * Does not contain any further information.
 */
public class MainActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        getWindow().addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);
    }

    public void configGame(View view) {
        startActivity(new Intent(MainActivity.this, Config.class));
    }
}