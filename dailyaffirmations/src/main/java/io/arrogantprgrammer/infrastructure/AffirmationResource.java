package io.arrogantprgrammer.infrastructure;

import io.arrogantprgrammer.domain.Affirmation;
import jakarta.transaction.Transactional;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;

import java.util.Random;

@Path("/affirmations")
@Consumes(MediaType.APPLICATION_JSON)
@Produces(MediaType.APPLICATION_JSON)
public class AffirmationResource {

    @GET
    public Response randomAffirmation() {
        return Response.ok(Affirmation.listAll().get(new Random().nextInt(Affirmation.listAll().size()))).build();
    }

    @POST
    @Transactional
    public Response createAffirmation(Affirmation affirmation) {
        affirmation.persist();
        return Response.status(Response.Status.CREATED).entity(affirmation).build();
    }

    @PUT
    @Transactional
    public Response updateAffirmation(final Affirmation updatedAffirmation) {
        Affirmation affirmation = Affirmation.findById(updatedAffirmation.id);
        affirmation.setText(updatedAffirmation.getText());
        affirmation.setAuthor(updatedAffirmation.getAuthor());
        affirmation.persist();
        return Response.ok(affirmation).build();
    }

    @DELETE
    @Path("/{id}")
    @Transactional
    public Response deleteAffirmation(@PathParam("id") Long id) {
        Affirmation.findById(id).delete();
        return Response.ok().build();
    }
}
