package com.example.crosstheroad;

import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.RadioButton;
import android.widget.RadioGroup;
import android.widget.Toast;

/**
 * Config Class - sets up the game screen configuration.
 * This is more backend - takes in user input and displays.
 * Attributes:
 *      username - String
 * Methods:
 *      getter/setter for username
 *      set Kitty/Turtle/Frog
 *          -depends on user input
 *      startGame method
 *          handles the bulk of the action
 */
public class Config extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_config);

    }

    private String username;

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public boolean isBlankTest(String string) {
        if (string == null) {
            return true;
        }
        return string.trim().isEmpty();
    }

    public void startGame(View view) {
        EditText editTextSender = (EditText) findViewById(R.id.getText);
        String txt = editTextSender.getText().toString();
        setUsername(txt);
        if (isBlankTest(txt)) {
            Toast.makeText(this, "Invalid Username", Toast.LENGTH_SHORT).show();
        } else {
            RadioGroup rg = (RadioGroup) findViewById(R.id.radioGroup);
            String diff = ((RadioButton) findViewById(rg.getCheckedRadioButtonId()))
                    .getText().toString();
            RadioGroup rg2 = (RadioGroup) findViewById(R.id.radioGroup2);
            String sprite = ((RadioButton) findViewById(rg2.getCheckedRadioButtonId()))
                    .getText().toString();

            Intent intent = new Intent(this, Game.class);
            intent.putExtra("EXTRA_USERNAME", txt);
            intent.putExtra("EXTRA_DIFF", diff);
            intent.putExtra("EXTRA_SPRITE", sprite);

            startActivity(intent);
        }
    }

    public void setKitty(View view) {
        ImageView img = (ImageView) findViewById(R.id.imageView2);
        img.setImageResource(R.drawable.cat);
    }

    public void setTurtle(View view) {
        ImageView img = (ImageView) findViewById(R.id.imageView2);
        img.setImageResource(R.drawable.turtle);
    }

    public void setFrog(View view) {
        ImageView img = (ImageView) findViewById(R.id.imageView2);
        img.setImageResource(R.drawable.frog);
    }

}