package com.example.wox;

import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import android.os.Bundle;
import android.app.WallpaperManager;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import java.io.File;
import android.content.Intent;
import android.net.Uri;
import java.io.IOException;
import android.app.Activity;
import java.util.*;
import android.widget.Toast;


public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "com.muhammadhanan.wox/essentials";

     @Override
  public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
    super.configureFlutterEngine(flutterEngine);

    new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
        .setMethodCallHandler(
            (call, result) ->{
                String data= call.arguments();
                if(call.method.equals("setWallpaper")){
                    String[] str = data.split(" ");
                    File imgFile = new File(str[0]);
                    Bitmap bitmap = BitmapFactory.decodeFile(imgFile.getAbsolutePath());
                    WallpaperManager wallpapermanager = null;
                    wallpapermanager= WallpaperManager.getInstance(this);
                    try{
                        if(str[1].equals("home")){
                            wallpapermanager.setBitmap(bitmap,null,true,WallpaperManager.FLAG_SYSTEM);
                        }else if(str[1].equals("lock")){
                            wallpapermanager.setBitmap(bitmap, null, true, WallpaperManager.FLAG_LOCK);
                        }else if(str[1].equals("both")){
                            wallpapermanager.setBitmap(bitmap);
                        }
                        result.success("Applied Wallpaper");
                    }catch(IOException e){
                        result.success("failed");
                    }
                }else if(call.method.equals("showToast")){
                    try{
                        String str = data;
                        Toast.makeText(getApplicationContext(), str,Toast.LENGTH_SHORT).show();
                        result.success("Showed Toast");
                    }catch(Exception e){
                        result.success("failed");
                    }
                }

            });
  }

}
