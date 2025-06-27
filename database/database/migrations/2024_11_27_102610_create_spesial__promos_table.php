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
        Schema::create('spesialPromos', function (Blueprint $table) {
            $table->id();
            $table->string('judul');
            $table->string('status');
            $table->date('tanggalBerlaku');
            $table->double('harga');
            $table->string('ketentuan');
            $table->string('fotoPromo');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('spesial__promos');
    }
};
