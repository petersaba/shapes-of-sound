<?php

use App\Http\Controllers\AuthController;
use App\Http\Controllers\TranscribeController;
use Illuminate\Support\Facades\Route;



Route::post('signup', [AuthController::class, 'createUser']);
Route::post('login', [AuthController::class, 'login'])->name('login');
Route::group(['middleware' => 'auth:api'], function(){
    Route::post('transcribe', [TranscribeController::class, 'transcribeAudio']);
    Route::get('users', [AuthController::class, 'getUserInfo']);
    Route::post('edit', [AuthController::class, 'editUserInfo']);
});