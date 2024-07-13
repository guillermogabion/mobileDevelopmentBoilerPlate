<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;

class UsersController extends Controller
{
    //
    public function index(Request $request)
    {
        $search = $request->input('search');
        $table_header = [
            'User ID',
            'Full Name',
            'Username',
            'Address',
            'Role',
            'Status',
            'Action'
        ];
        $items = User::when($search, function ($query, $search) {
            return $query->where('firstName', 'like', '%' . $search . '%')
                ->orWhere('lastName', 'like', '%' . $search . '%')
                ->orWhere('name', 'like', '%' . $search . '%')
                ->orWhere('address', 'like', '%' . $search . '%')
                ->orWhere('email', 'like', '%' . $search . '%');
        })->where('role', 'student')
            ->orderBy('created_at', 'desc')
            ->paginate(10);

        return view('pages.users', ['headers' => $table_header, 'items' => $items, 'search' => $search]);
    }

    public function store(Request $request)
    {
        $request->validate([
            'firstName' => 'required|string|max:255',
            'lastName' => 'required|string|max:255',
            'address' => 'required|string|max:255',
            'name' => 'required|string|max:255',
            'email' => 'required|string|email|max:255|unique:users,email',
            'role' => 'required|string',
            'password' => 'required|string|min:8|confirmed', // Added validation rules for password
        ]);

        // Create a new user with hashed password
        User::create([
            'firstName' => $request->input('firstName'),
            'lastName' => $request->input('lastName'),
            'address' => $request->input('address'),
            'name' => $request->input('name'),
            'email' => $request->input('email'),
            'role' => $request->input('role'),
            'password' => Hash::make($request->input('password')), // Hash the password
        ]);

        return redirect()->route('users');
    }

    public function update(Request $request)
    {
        $request->validate([
            'firstName' => 'string|max:255',
            'lastName' => 'string|max:255',
            'address' => 'string|max:255',
            'name' => 'string|max:255',
            'role' => 'string',
        ]);

        // Create a new user with hashed password
        $item = User::findOrFail($request->id);
        $item->update($request->all());
        return redirect()->route('users')->with('success', 'User updated successfully');
    }
    public function updateStatus(Request $request)
    {
        $request->validate([
            'status' => 'required|string|in:pending,approved',
        ]);

        $user = User::findOrFail($request->id);
        $user->status = $request->input('status');
        $user->save();

        return redirect()->route('users')->with('success', 'User status updated successfully');
    }


    public function self()
    {
        $user = User::find(auth()->user()->id);
        $token = $user->createToken('authToken')->accessToken;
        return response(['user' => $user, 'access_token' => $token]);
    }

    public function login(Request $request)
    {
        $login = $this->validate($request, [
            'name' => 'required',
            'password' => 'required',
        ]);
        $user = User::where('name', $request->name)->first();
        if (!Auth::attempt($login)) {
            return response(['message' => 'login Credentials are incorrect'], 500);
        }
        $token = $user->createToken('authToken')->accessToken;
        return response(['user' => Auth::user(), 'access_token' => $token]);
    }

    public function logout(Request $request)
    {
        $request->user()->tokem()->delete();
    }
    public function indexMobile()
    {
        return User::get();
    }
}
