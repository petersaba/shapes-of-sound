<?php

namespace App\Http\Controllers;

use Illuminate\Support\Facades\Auth;
use App\Http\Controllers\Controller;
use App\Models\Favorite;
use Tymon\JWTAuth\Facades\JWTAuth;

use App\Models\User;
use Illuminate\Database\Console\Migrations\StatusCommand;
use Illuminate\Http\Request;

use function PHPUnit\Framework\isEmpty;

class AuthController extends Controller
{

    

    /**
     * Get a JWT via given credentials.
     * 
     *
     * @return \Illuminate\Http\JsonResponse
     */

    // public function login()
    // {
    //     $credentials = request(['email', 'password']);

    //     if (! $token = JWTAuth::attempt($credentials)) {
    //         return response()->json(['error' => 'Unauthorized'], 401);
    //     }

    //     return $this->respondWithToken($token);
    // }

    /**
     * Get the authenticated User.
     *
     * @return \Illuminate\Http\JsonResponse
     */

    // public function me()
    // {
    //     return response()->json(auth()->user());
    // }

    /**
     * Log the user out (Invalidate the token).
     *
     * @return \Illuminate\Http\JsonResponse
     */

    // public function logout()
    // {
    //     auth()->logout();

    //     return response()->json(['message' => 'Successfully logged out']);
    // }

    /**
     * Refresh a token.
     *
     * @return \Illuminate\Http\JsonResponse
     */
    // public function refresh()
    // {
    //     return $this->respondWithToken(auth()->refresh());
    // }

    /**
     * Get the token array structure.
     *
     * @param  string $token
     *
     * @return \Illuminate\Http\JsonResponse
     */

    // protected function respondWithToken($token)
    // {
    //     return response()->json([
    //         'access_token' => $token,
    //         'token_type' => 'bearer',
    //         'expires_in' => config('jwt.ttl')
    //     ]);
    // }

    function createUser(Request $request){

        $validator = validator()->make($request->all(), [
            'full_name' => 'string|required',
            'email' => 'email|required',
            'password' => 'string|required',
            'gender' => ['regex:/^(male|female)$/i', 'required']
        ]);

        if ($validator->fails()){
            return response()->json([
                'success' => FALSE,
                'message' => 'input format is invalid'
            ], 400);
        }

        if (count(self::isAttributeUsed('email', $request->email)) != 0){
            return response()->json([
                'success' => FALSE,
                'message' => 'email is already in use'
            ], 400);  
        }

        $user = new User;
            $user->email = $request->email;
            $user->full_name = $request->full_name;
            $user->password = bcrypt($request->password);
            $user->gender = strtolower($request->gender);
    
            if($user->save()) {
                return response()->json([
                    'success' => TRUE,
                    'request' => $request->email,
                    'db' => self::isAttributeUsed('email', $request->email)]);
            }
    }

    function isAttributeUsed($attribute_name, $attribute_value){
        return User::where($attribute_name, $attribute_value)->get();
    }
}