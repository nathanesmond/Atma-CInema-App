<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Review extends Model
{
    use HasFactory;

    public $timestamps = false;

    protected $table = "reviews";

    protected $primaryKey = "id";

    protected $fillable = [
        'idFilm',
        'idHistory',
        'review',
        'rating',
    ];

    public function film(){
        return $this->belongsTo(Film::class, 'idFilm', 'id');
    }

    public function history(){
        return $this->belongsTo(History::class, 'idHistory', 'id');
    }

}
