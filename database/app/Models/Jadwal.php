<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Jadwal extends Model
{
    use HasFactory;

    public $timestamps = false;

    protected $table = "jadwals";

    protected $primaryKey = "id";

    protected $fillable = [
        'jamTayang',
    ];

    public function JadwalTayang(){
        return $this->hasMany(JadwalTayang::class);
    }
}
