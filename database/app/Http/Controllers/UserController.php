<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;
use Exception;
use Carbon\Carbon;

class UserController extends Controller
{
    public function register(Request $request)
    {
        $request->validate([
            'username' => 'required',
            'tanggalLahir' => 'required',
            'noTelepon' => 'required',
            'email' => 'required|string|email|max:255|unique:users,email',
            'password' => 'required',
        ]);

        try {

            $tanggalLahir = Carbon::createFromFormat('Y-m-d', $request->tanggalLahir)->toDateString();

            User::create([
                'username' => $request->username,
                'tanggalLahir' => $tanggalLahir,
                'noTelepon' => $request->noTelepon,
                'email' => $request->email,
                'password' => Hash::make($request->password),
                'foto' => "profilepict/profile.jpg",
            ]);

            return response()->json([ // respon ketika berhasil
                "status" => true,
                "message" => "Register Successful",
            ], 200);

        } catch (Exception $e) {
            return response()->json([ // respon ketika berhasil
                "status" => false,
                "message" => "Register Failed",
            ], 401);
        }
    }

    public function login(Request $request)
    {
        $request->validate([
            'email' => 'required|email',
            'password' => 'required',
        ]);

        try {
            $users = User::where('email', $request->email)->first();

            if (!$users && !Hash::check($request->password, $users->password)) {
                return response()->json([
                    'message' => 'email atau password salah'
                ], 401);
            }


            $token = $users->createToken('Personal Access Token')->plainTextToken;

            return response()->json([ // respon ketika berhasil
                "status" => true,
                "data" => $users,
                'token' => $token
            ], 200);

        } catch (Exception $e) {
            return response()->json([ // respon ketika gagal
                "status" => false,
                "message" => $e,
            ], 401);
        }

    }

    public function logout(Request $request)
    {
        try {
            // Check if the user is authenticated and has a current token
            if ($request->user() && $request->user()->currentAccessToken()) {
                // Delete the current access token
                $request->user()->currentAccessToken()->delete();
            } else {
                // Optional: Delete all tokens if currentAccessToken is null
                if ($request->user()) {
                    $request->user()->tokens()->delete();
                }
            }

            return response()->json([
                'message' => 'Logout Successful'
            ], 200);


        } catch (Exception $e) {
            return response()->json([ // respon ketika gagal
                "status" => false,
                "message" => $e,
            ], 401);
        }
    }

    /**
     * Display a listing of the resource.
     */

    public function index()
    {
        $oneUser = Auth::user();
        return response()->json([
            "status" => true,
            "message" => 'berhasil',
            "data" => $oneUser,
        ], 200);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request)
    {
        try {
            // Validasi data yang diterima
            $validatedData = $request->validate([
                'username' => 'required|string|max:255',
                'email' => 'required|string|email|max:255|unique:users,email,' . Auth::user()->id,
                'noTelepon' => 'required',
                'tanggalLahir' => 'required|date',
                'password' => 'nullable',
                'foto' => 'nullable|image|mimes:jpeg,png,jpg|max:2048',
            ]);

            // Mendapatkan ID pengguna yang sedang login
            $userId = Auth::user()->id;

            // Menemukan pengguna yang akan diupdate
            $user = User::findOrFail($userId);

            // Cek dan simpan foto jika ada
            if ($request->hasFile('foto')) {
                $file = $request->file('foto');
                $fileName = time() . '_' . $file->getClientOriginalName(); 
                $file->move(public_path('storage/profilepict'), $fileName);

                // Update path foto di database
                $user->foto = 'profilepict/' . $fileName;
            }

            // Update data lainnya
            $user->username = $validatedData['username'];
            $user->email = $validatedData['email'];
            $user->noTelepon = $validatedData['noTelepon'];
            $user->tanggalLahir = $validatedData['tanggalLahir'];

            // Update password jika diubah
            if ($request->filled('password')) {
                $user->password = Hash::make($validatedData['password']);
            }

            // Simpan perubahan
            $user->save();

            return response()->json([
                'message' => 'Profile updated successfully',
                'user' => $user
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Failed to update profile',
                'error' => $e->getMessage(),
            ], 500);
        }
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(User $user)
    {
        $userId = Auth::user()->idUser;

        $user = User::find($userId);

        if (!$user) {
            return response()->json(['message' => 'User tidak ditemukan atau anda tidak login'], 403);
        }

        $user->delete();

        return response()->json(['message' => 'User berhasil di hapus.']);
    }

    public function profile()
    {
        // Get the authenticated user
        $user = Auth::user();

        // Pass the user data to the profile view
        return view('profile', compact('user'));
    }

}
