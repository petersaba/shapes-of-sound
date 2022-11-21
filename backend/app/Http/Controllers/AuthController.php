<?php

namespace App\Http\Controllers;

use Illuminate\Support\Facades\Auth;
use App\Http\Controllers\Controller;
use Tymon\JWTAuth\Facades\JWTAuth;
use App\Models\User;
use Illuminate\Http\Request;

class AuthController extends Controller
{

    public function login()
    {
        $credentials = request(['email', 'password']);

        if (!$token = JWTAuth::attempt($credentials)) {
            return response()->json(['error' => 'Unauthorized'], 401);
        }

        return $this->respondWithToken($token);
    }

    public function logout()
    {
        auth()->logout();

        return response()->json(['message' => 'Successfully logged out']);
    }

    /**
     * Refresh a token.
     *
     * @return \Illuminate\Http\JsonResponse
     */
    // public function refresh()
    // {
    //     return $this->respondWithToken(auth()->refresh());
    // }

    protected function respondWithToken($token)
    {
        return response()->json([
            'access_token' => $token,
            'token_type' => 'bearer',
            'expires_in' => config('jwt.ttl')
        ]);
    }

    function createUser(Request $request)
    {

        $validator = validator()->make($request->all(), [
            'full_name' => 'string|required',
            'email' => 'email|required',
            'password' => 'string|required',
            'gender' => ['regex:/^(male|female)$/i', 'required']
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => FALSE,
                'message' => 'input format is invalid'
            ], 400);
        }

        if (count(self::isAttributeUsed('email', $request->email)) != 0) {
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
        $user->image_path = $request->base64_image ? self::saveImage($request->base64_image, $request->email) : NULL;

        if ($user->save()) {
            return response()->json([
                'success' => TRUE,
                'request' => $request->email,
                'db' => self::isAttributeUsed('email', $request->email)
            ]);
        }
    }

    function getUserInfo() {
        if (Auth::check()){
            return response()->json([
                'success' => TRUE,
                'user' => Auth::user()
            ]);
        }
    }

    function editUserInfo(Request $request){

        $validator = validator()->make($request->all(), [
            'password' => 'string',
            'full_name' => 'string',
        ]);

        if ($validator->fails()){
            return response()->json([
                'success' => FALSE,
                'message' => 'input data is invalid'
            ]);
        }

        $user = User::find(Auth::id());

        if (isset($request->full_name)){
            $user->full_name = $request->full_name;
        }

        if (isset($request->password)){
            $user->password = bcrypt($request->password);
        }

        if (isset($request->base64_image)){
            $user->image_path = self::saveImage($request->base64_image, $request->email ? $request->email : $user->email);
        }

        if($user->save()){
            return response()->json([
                'success' => TRUE,
            ]);
        }
    }

    function saveImage($base64_image, $user_email){
        $images_path = './images/';
        $image_name = $user_email . date('Y-m-d-H-i-s') . '.jpg';

        if (!is_dir($images_path)){
            mkdir($images_path);
        }
        $decoded_image = base64_decode($base64_image);

        file_put_contents($images_path . $image_name, $decoded_image);
        return $image_name;
    }

    function isAttributeUsed($attribute_name, $attribute_value)
    {
        return User::where($attribute_name, $attribute_value)->get();
    }
}
