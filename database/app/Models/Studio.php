<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Studio extends Model
{
    use HasFactory;

    public $timestamps = false;

    protected $table = "studios";

    protected $primaryKey = "id";

    protected $fillable = [
        'jenis',
        'jumlahKursi',
        'harga',
    ];

    public function JadwalTayang(){
        return $this->hasMany(JadwalTayang::class);
    }
}
