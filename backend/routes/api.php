<?php

use App\Http\Controllers\AuthController;
use App\Http\Controllers\TranscribeController;
use Illuminate\Support\Facades\Route;



Route::post('signup', [AuthController::class, 'createUser']);
Route::post('login', [AuthController::class, 'login']);
Route::group(['Middleware' => 'auth:api'], function(){
    Route::post('transcribe', [TranscribeController::class, 'transcribeAudio']);
    Route::get('users', [AuthController::class, 'getUserInfo']);
});