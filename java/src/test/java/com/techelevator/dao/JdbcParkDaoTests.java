package com.techelevator.dao;

import com.techelevator.model.Park;

import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;

import java.util.ArrayList;
import java.util.List;

public class JdbcParkDaoTests extends BaseDaoTests {

    private ParkDao dao;

    @Before
    public void setup() {
        dao = new JdbcParkDao(dataSource);
    }

    @Test
    public void getParks_Should_Return_All_Parks() {
    List<Park> parks = dao.getParks();
    Assert.assertNotNull(parks);
    assertParksMatch(1, parks.get(0));
    assertParksMatch(2, parks.get(1));

    }

    private void assertParksMatch(int id , Park actual) {
        Assert.assertEquals("Park id doesn't match", id, actual.getParkId());

    }
}
