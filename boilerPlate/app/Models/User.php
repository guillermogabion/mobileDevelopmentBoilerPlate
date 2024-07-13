<?php

namespace App\Models;

use Illuminate\Contracts\Auth\MustVerifyEmail;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Passport\HasApiTokens;

class User extends Authenticatable
{
    use HasApiTokens, HasFactory, Notifiable;

    /**
     * The attributes that are mass assignable.
     *
     * @var array<int, string>
     */
    protected $fillable = [
        'firstName', 'lastName', 'address', 'role', 'name', 'email', 'password'
    ];

    public function classSet()
    {
        return $this->belongsToMany(ClassSet::class);
    }


    public function classrooms()
    {
        return $this->belongsToMany(Classroom::class, 'classroom_user_classset')
            ->withPivot('class_set_id')
            ->withTimestamps();
    }

    public function classSets()
    {
        return $this->belongsToMany(ClassSet::class, 'classroom_user_classset')
            ->withPivot('classroom_id')
            ->withTimestamps();
    }
    /**
     * The attributes that should be hidden for serialization.
     *
     * @var array<int, string>
     */
    protected $hidden = [
        'password',
        'remember_token',
    ];

    /**
     * The attributes that should be cast.
     *
     * @var array<string, string>
     */
    protected $casts = [
        'email_verified_at' => 'datetime',
    ];
}
