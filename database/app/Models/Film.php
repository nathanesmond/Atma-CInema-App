<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Film extends Model
{
    use HasFactory;

    public $timestamps = false;

    protected $table = "films";

    protected $primaryKey = "id";

    protected $fillable = [
        'judul',
        'status',
        'durasi',
        'genre',
        'ageRestriction',
        'deskripsi',
        'sinopsis',
        'jumlahRating',
        'fotoFilm',
    ];

    public function review(){
        return $this->hasMany(Review::class);
    }

    public function JadwalTayang(){
        return $this->hasMany(JadwalTayang::class);
    }
    

}
