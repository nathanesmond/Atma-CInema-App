<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Laravel\Sanctum\HasApiTokens;

use Illuminate\Foundation\Auth\User as Authenticatable;

class User extends Authenticatable
{
    use HasFactory, HasApiTokens;

    public $timestamps = false;

    protected $table = "users";

    protected $primaryKey = "id";

    protected $fillable = [
        'username',
        'password',
        'tanggalLahir',
        'email',
        'noTelepon',
        'foto',
    ];

    public function transaksi(){
        return $this->hasMany(Transaksi::class);
    }
    public function history(){
        return $this->hasMany(History::class);
    }

}
