<div class="modal-overlay" id="rejectModal">
    <div class="futuristic-modal">
        <form action="" method="POST">
            <div class="modal-header">
                <h3><i class='bx bxs-error-circle'></i> Tolak Pesanan</h3>
            </div>
            
            <div class="modal-body">
                <input type="hidden" name="action" value="reject">
                <input type="hidden" name="order_id" id="input_order_id">
                
                <p>Silakan masukkan alasan penolakan agar pelanggan dapat mengetahuinya:</p>
                <textarea name="alasan_tolak" rows="4" required placeholder="Tulis alasan di sini..."></textarea>
            </div>
            
            <div class="modal-footer">
                <button type="button" class="btn-action btn-cancel" onclick="closeModal()">Batal</button>
                <button type="submit" class="btn-action btn-tolak">Konfirmasi</button>
            </div>
        </form>
    </div>
</div>

<script>
    function openRejectModal(orderId) {
        document.getElementById('input_order_id').value = orderId;
        const modal = document.getElementById('rejectModal');
        modal.style.display = 'flex';
        setTimeout(() => modal.classList.add('show'), 10);
    }

    function closeModal() {
        const modal = document.getElementById('rejectModal');
        modal.classList.remove('show');
        setTimeout(() => modal.style.display = 'none', 300);
    }

    window.onclick = function (event) {
        const modal = document.getElementById('rejectModal');
        if (event.target == modal) { closeModal(); }
    }
</script>