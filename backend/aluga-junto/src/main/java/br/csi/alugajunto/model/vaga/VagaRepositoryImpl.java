package br.csi.alugajunto.model.vaga;

import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.criteria.*;
import org.springframework.stereotype.Repository;

import java.util.ArrayList;
import java.util.List;

@Repository
public class VagaRepositoryImpl implements VagaRepositoryCustom {
    @PersistenceContext
    private EntityManager em;

    @Override
    public List<Vaga> buscarComFiltros(FiltroVagaDTO filtro) {
        CriteriaBuilder cb = em.getCriteriaBuilder();
        CriteriaQuery<Vaga> cq = cb.createQuery(Vaga.class);
        Root<Vaga> vaga = cq.from(Vaga.class);

        // joins
        Join<Object, Object> endereco = vaga.join("endereco", JoinType.LEFT);
        Join<Object, Object> perfil = vaga.join("perfil", JoinType.LEFT);

        List<Predicate> predicates = new ArrayList<>();

        if (filtro.getGenero() != null && !filtro.getGenero().isEmpty()) {
            predicates.add(cb.equal(cb.lower(perfil.get("genero")), filtro.getGenero().toLowerCase()));
        }

        if (filtro.getPet() != null) {
            predicates.add(cb.equal(perfil.get("pet"), filtro.getPet()));
        }

        if (filtro.getFumante() != null) {
            predicates.add(cb.equal(perfil.get("fumante"), filtro.getFumante()));
        }

        if (filtro.getCidade() != null && !filtro.getCidade().isEmpty()) {
            predicates.add(cb.like(cb.lower(endereco.get("cidade")), "%" + filtro.getCidade().toLowerCase() + "%"));
        }

        if (filtro.getEstado() != null && !filtro.getEstado().isEmpty()) {
            predicates.add(cb.like(cb.lower(endereco.get("estado")), "%" + filtro.getEstado().toLowerCase() + "%"));
        }

        if (filtro.getBairro() != null && !filtro.getBairro().isEmpty()) {
            predicates.add(cb.like(cb.lower(endereco.get("bairro")), "%" + filtro.getBairro().toLowerCase() + "%"));
        }

        cq.where(predicates.toArray(new Predicate[0]));
        return em.createQuery(cq).getResultList();
    }
}
