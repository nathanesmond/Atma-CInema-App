<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('jadwalTayangs', function (Blueprint $table) {
            $table->id();
            $table->unsignedBigInteger('idStudio');
            $table->foreign('idStudio')->references('id')->on('studios')->onDelete('cascade');
            $table->unsignedBigInteger('idJadwal');
            $table->foreign('idJadwal')->references('id')->on('jadwals')->onDelete('cascade');
            $table->unsignedBigInteger('idFilm');
            $table->foreign('idFilm')->references('id')->on('films')->onDelete('cascade');
            $table->date('tanggalTayang');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('jadwalTayangs');
    }
};
