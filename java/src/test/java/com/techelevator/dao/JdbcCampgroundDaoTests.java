package com.techelevator.dao;

import com.techelevator.model.Campground;

import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;

import java.util.ArrayList;
import java.util.List;

import static org.junit.Assert.assertEquals;

public class JdbcCampgroundDaoTests extends BaseDaoTests {

    private CampgroundDao dao;

    @Before
    public void setup() {
        dao = new JdbcCampgroundDao(dataSource);
    }

    @Test
    public void getCampgroundById_Should_Return_Specific_Campground() {
        Campground campground = dao.getCampgroundById(1);

        assertEquals("Incorrect campground returned for ID 1", 1, campground.getCampgroundId());
    }

    @Test
    public void getCampgroundsByParkId_Should_Return_All_Campgrounds_For_Park() {
        List<Campground> campgrounds = dao.getCampgroundsByParkId(1);
        Assert.assertNotNull(campgrounds);
        assertCampgroundsMatch(dao.getCampgroundById(1), campgrounds.get(0));
        assertCampgroundsMatch(dao.getCampgroundById(2), campgrounds.get(1));

        campgrounds = dao.getCampgroundsByParkId(2);
        Assert.assertNotNull(campgrounds);
        Assert.assertEquals(0, campgrounds.size());
    }

    private void assertCampgroundsMatch(Campground expected, Campground actual){
        Assert.assertEquals("Campground id doesn't match", expected.getCampgroundId(), actual.getCampgroundId());
        Assert.assertEquals("Campground park id doesn't match", expected.getParkId(), actual.getParkId());
        Assert.assertEquals("Campground name doesn't match", expected.getName(), actual.getName());
        Assert.assertEquals("Campground open from month doesn't match", expected.getOpenFromMonth(), actual.getOpenFromMonth());
        Assert.assertEquals("Campground open to month doesn't match", expected.getOpenToMonth(), actual.getOpenToMonth());
        Assert.assertEquals("Campground daily fee doesn't match", expected.getDailyFee(), actual.getDailyFee(), .001);
    }

}
