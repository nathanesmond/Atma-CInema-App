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
        Schema::create('menus', function (Blueprint $table) {
            $table->id();
            $table->unsignedBigInteger('idSpesialPromo');
            $table->foreign('idSpesialPromo')->references('id')->on('spesialpromos')->onDelete('cascade');
            $table->string('jenis');
            $table->string('nama');
            $table->double('harga');
            $table->string('deskripsi');
            $table->string('fotoMenu');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('menus');
    }
};
