<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class JadwalTayang extends Model
{
    use HasFactory;

    public $timestamps = false;

    protected $table = "jadwalTayangs";

    protected $primaryKey = "id";

    protected $fillable = [
        'idStudio',
        'idJadwal',
        'idFilm',
        'tanggalTayang',
    ];

    public function film(){
        return $this->belongsTo(Film::class, 'idFilm', 'id');
    }
    
    public function studio(){
        return $this->belongsTo(Studio::class, 'idStudio', 'id');
    }

    public function jadwal(){
        return $this->belongsTo(Jadwal::class, 'idJadwal', 'id');
    }

    public function pemesananTiket(){
        return $this->hasMany(PemesananTiket::class);
    }

}
