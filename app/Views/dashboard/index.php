<?php
$tituloPagina = 'Dashboard';
require __DIR__ . '/../layouts/header.php';
?>
<div class="d-flex flex-wrap justify-content-between align-items-center gap-2 mb-4">
    <div>
        <h1 class="h3 mb-1">Dashboard</h1>
        <p class="text-secondary mb-0">Visão geral dos atendimentos do AtendeLab.</p>
    </div>
</div>

<div id="alerta"></div>

<!-- Totais gerais -->
<div class="row g-3 mb-3">
    <div class="col-md-4">
        <div class="card border-0 shadow-sm h-100">
            <div class="card-body">
                <div class="text-secondary small">Pessoas cadastradas</div>
                <div class="display-6 fw-semibold" id="totalPessoas">--</div>
                <div class="small text-secondary"><span id="pessoasAtivas">--</span> ativas</div>
            </div>
        </div>
    </div>
    <div class="col-md-4">
        <div class="card border-0 shadow-sm h-100">
            <div class="card-body">
                <div class="text-secondary small">Tipos de atendimento</div>
                <div class="display-6 fw-semibold" id="totalTipos">--</div>
            </div>
        </div>
    </div>
    <div class="col-md-4">
        <div class="card border-0 shadow-sm h-100">
            <div class="card-body">
                <div class="text-secondary small">Atendimentos registrados</div>
                <div class="display-6 fw-semibold" id="totalAtendimentos">--</div>
            </div>
        </div>
    </div>
</div>



<div class="card border-0 shadow-sm">
    <div class="card-body">
        <h2 class="h5">Acesso rápido</h2>
        <div class="d-flex flex-wrap gap-2">
            <a class="btn btn-success" href="<?= $baseUrl ?>?controller=frontend&action=pessoas">Gerenciar pessoas</a>
            <a class="btn btn-outline-success" href="<?= $baseUrl ?>?controller=frontend&action=tipos">Gerenciar tipos de atendimento</a>
            <a class="btn btn-outline-success" href="<?= $baseUrl ?>?controller=frontend&action=atendimentos">Gerenciar atendimentos</a>
        </div>
    </div>
</div>

<script>
const STATUS_INFO = {
    aberto: { label: 'Aberto', classe: 'text-bg-primary' },
    em_andamento: { label: 'Em andamento', classe: 'text-bg-warning' },
    concluido: { label: 'Concluído', classe: 'text-bg-success' },
    cancelado: { label: 'Cancelado', classe: 'text-bg-danger' }
};

function badgeStatus(status) {
    const info = STATUS_INFO[status] || { label: status, classe: 'text-bg-secondary' };
    return `<span class="badge ${info.classe}">${AtendeLabApi.escape(info.label)}</span>`;
}

// Converte 'YYYY-MM-DD' (ou com horário) para 'DD/MM/YYYY'.
function formatarData(valor) {
    if (!valor) return '';
    const m = String(valor).match(/^(\d{4})-(\d{2})-(\d{2})/);
    return m ? `${m[3]}/${m[2]}/${m[1]}` : valor;
}

function setText(id, value) {
    const el = document.getElementById(id);
    if (el) el.textContent = value;
}

document.addEventListener('DOMContentLoaded', async () => {
    try {
        const dados = await AtendeLabApi.get('dashboard', 'resumo');
        const ind = dados.indicadores || {};

        setText('totalPessoas', ind.total_pessoas ?? 0);
        setText('pessoasAtivas', ind.pessoas_ativas ?? 0);
        setText('totalTipos', ind.total_tipos ?? 0);
        setText('totalAtendimentos', ind.total_atendimentos ?? 0);
        setText('statAbertos', ind.abertos ?? 0);
        setText('statAndamento', ind.em_andamento ?? 0);
        setText('statConcluidos', ind.concluidos ?? 0);
        setText('statCancelados', ind.cancelados ?? 0);

        // Top pessoas
        const top = Array.isArray(dados.top_pessoas) ? dados.top_pessoas : [];
        const tbodyTop = document.getElementById('tabelaTopPessoas');
        tbodyTop.innerHTML = top.length
            ? top.map(p => `
                <tr>
                    <td>${AtendeLabApi.escape(p.nome)}</td>
                    <td class="text-center">${AtendeLabApi.escape(p.total)}</td>
                    <td class="text-center">${Number(p.em_aberto || 0) > 0
                        ? `<span class="badge text-bg-warning">${Number(p.em_aberto)}</span>`
                        : '<span class="text-secondary">0</span>'}</td>
                </tr>`).join('')
            : '<tr><td colspan="3" class="text-center py-4">Nenhum atendimento ainda.</td></tr>';

        // Recentes
        const recentes = Array.isArray(dados.atendimentos_recentes) ? dados.atendimentos_recentes : [];
        const tbodyRec = document.getElementById('tabelaRecentes');
        tbodyRec.innerHTML = recentes.length
            ? recentes.map(a => `
                <tr>
                    <td>${AtendeLabApi.escape(a.id)}</td>
                    <td>${AtendeLabApi.escape(a.pessoa_nome)}</td>
                    <td>${badgeStatus(a.status)}</td>
                    <td>${AtendeLabApi.escape(formatarData(a.data_atendimento))}</td>
                </tr>`).join('')
            : '<tr><td colspan="4" class="text-center py-4">Nenhum atendimento recente.</td></tr>';
    } catch (error) {
        AtendeLabApi.showAlert('alerta', error.message, 'danger');
    }
});
</script>

<?php require __DIR__ . '/../layouts/footer.php'; ?>
